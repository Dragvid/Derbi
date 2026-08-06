# PauseMenu.gd
extends Control

#@onready var pause_panel: Panel = $PausePanel
@onready var resume_button: Button = $VBoxContainer/tab_separator/resume_button
@onready var quit_button: Button = $VBoxContainer/tab_separator/quit_button
@onready var tab_parent: Control = $VBoxContainer/tab_parent

@export var tab_scenes: Array[PackedScene]

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS  # runs even when paused
	resume_button.pressed.connect(_on_resume)
	quit_button.pressed.connect(_on_quit)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # Escape key by default
		toggle_pause()

func toggle_pause() -> void:
	var is_paused = !get_tree().paused
	get_tree().paused = is_paused
	visible = is_paused
	if is_paused:
		resume_button.grab_focus()

func _on_resume() -> void:
	toggle_pause()

func _on_quit() -> void:
	get_tree().paused = false
	#get_tree().change_scene_to_file(AppInfo.current_level)  # or your main menu scene

func get_scene_by_name(scene_name: String) -> PackedScene:
	for scene in tab_scenes:
		if scene.resource_path.get_file().get_basename() == scene_name:
			return scene
	return null

func Load_tab(tab_name:String):
	#clear tab
	if tab_parent.get_child_count() > 0:
		tab_parent.get_child(0).queue_free()
	#get right scene
	var right_scene = get_scene_by_name(tab_name)
	GeneralToolsStatic.instantiate_scene(right_scene.resource_path,tab_parent)


func _on_members_tab_button_button_up() -> void:
	Load_tab("Party_customization")


func _on_options_tab_button_button_up() -> void:
	Load_tab("options_scene")
