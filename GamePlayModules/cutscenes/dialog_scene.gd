extends Control
@export var test_string : String
@export var time_between_chars : float
@export var time_between_lines : float

var episode_to_show : String = AppInfo.current_chapter

@onready var dialog_label: Label = $separator/dialog_box/MarginContainer/MarginContainer/dialog_label
@onready var speaker_label: Label = $separator/dialog_box/speaker_box/speaker_label
@onready var portrait_side_a: TextureRect = $separator/portraits/separator/SideA/TextureRect
@onready var portrait_side_b: TextureRect = $separator/portraits/separator/SideB/TextureRect2
@onready var background_image: TextureRect = $separator/portraits/background_image
@onready var skip_button: Button = $MarginContainer/HBoxContainer/skip_Button
@onready var animation_player: AnimationPlayer = $AnimationPlayer

static var script_json = GeneralToolsStatic.get_dictionary_from_json("res://resources/story/story_resource.json")

var is_writing: bool = false
var skip_writing: bool = false
var skip_scene: bool = false
var autoplay:bool = false
var advance_line: bool = false

func _ready() -> void:
	#Write_line("test", test_string)
	#Play_scene("test")
	Play_scene(episode_to_show)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if is_writing:
			skip_writing = true  # signal the typewriter to skip

func Play_scene(scene_name: String):
	if not script_json.has(scene_name):
		print("Scene not found: ", scene_name)
		return
	for line in script_json[scene_name]:
		if line.has("portrait") and line.has("side"):
			await update_portrait(line["portrait"], line["side"])
		if line.has("speaker") and line.has("text"):
			await Write_line(line["speaker"], line["text"])
			if !autoplay:
				await wait_for_input()
			else:
				await get_tree().create_timer(time_between_lines).timeout
	#print("end of the scene")
	skip_button.text = "Next Level"
	animation_player.play("Pulse")

func wait_for_input() -> void:
	await get_tree().create_timer(0.1).timeout
	while not Input.is_action_just_released("ui_accept") and not advance_line:
		await get_tree().process_frame
	advance_line = false

func Write_line(speaker_name: String, current_line: String = "...") -> void:
	is_writing = true
	skip_writing = false
	dialog_label.text = ""
	speaker_label.text = speaker_name
	for character in current_line:
		if skip_writing:
			dialog_label.text = current_line  # dump the full line instantly
			break
		dialog_label.text += character
		await get_tree().create_timer(time_between_chars).timeout
	is_writing = false
	skip_writing = false

func update_portrait(new_image_path, side):
	var new_image = load(new_image_path)
	match side:
		"a":
			portrait_side_a.texture = new_image
			portrait_side_a.modulate.a = 1
			portrait_side_b.modulate.a = 0.5
		"b":
			portrait_side_b.texture = new_image
			portrait_side_b.modulate.a = 1
			portrait_side_a.modulate.a = 0.5
		"background":
			background_image.texture = new_image

func Advance_line():
	if is_writing:
		skip_writing = true
	else:
		advance_line = true

func Go_to_next_level():
	get_tree().change_scene_to_file(AppInfo.level_queue)
	
func _on_auto_button_button_up() -> void:
	autoplay = !autoplay
	Advance_line()

func _on_skip_button_button_up() -> void:
	advance_line = true  # unblock wait_for_input first
	await get_tree().process_frame  # let the while loop exit
	Go_to_next_level()

func _on_next_button_button_up() -> void:
	if autoplay:
		autoplay = false
	Advance_line()
