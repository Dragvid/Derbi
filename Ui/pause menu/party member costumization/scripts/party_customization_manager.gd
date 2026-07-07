extends Control
@onready var character_container: HBoxContainer = $VBoxContainer/characters/container
@export var character_button_scene: PackedScene

@export var attack_button_scene : PackedScene
@onready var unlocked_attacks_content: VBoxContainer = $VBoxContainer/pick_area/unlocked_attacks/ScrollContainer/content

@onready var equipped_attacks_content: VBoxContainer = $VBoxContainer/pick_area/current_attacks/ScrollContainer/content

var chosen_character = ""

func Load_character_buttons():
	for member in AppInfo.party_members:
		var new_button: Button = GeneralToolsStatic.instantiate_scene(character_button_scene.resource_path, character_container)
		new_button.get_child(0).text = member
		new_button.pressed.connect(_on_character_selected.bind(member))
	await get_tree().create_timer(0.01).timeout
	chosen_character = character_container.get_child(0).get_child(0).text
	Load_unlocked_attacks()  
	Load_equipped_attacks()

func _on_character_selected(member: String):#when the character button is clicked
	chosen_character = member
	Load_unlocked_attacks()
	Load_equipped_attacks()

func Load_unlocked_attacks():
	if chosen_character == "":
		return
	Clear_list(unlocked_attacks_content)
	for attack in AppInfo.save_file_json["unlocked_moves"]:
		if attack not in AppInfo.party_info_json[chosen_character]["attacks"]:
			#print("Can assign: ", attack)
			# create attack option
			var new_button: Button = GeneralToolsStatic.instantiate_scene(attack_button_scene.resource_path, unlocked_attacks_content)
			await get_tree().create_timer(0.01).timeout
			new_button.Write_info(attack,"equipar")

# Equipped attacks
func Load_equipped_attacks(): 
	if chosen_character == "":
		return
	Clear_list(equipped_attacks_content)
	var member_info = AppInfo.party_info_json[chosen_character]
	for attack in member_info["attacks"]:
		# create attack option
		var new_button: Button = GeneralToolsStatic.instantiate_scene(attack_button_scene.resource_path, equipped_attacks_content)
		await get_tree().create_timer(0.01).timeout
		new_button.Write_info(attack,"desequipar")

# ready
func _ready() -> void:
	Load_character_buttons()

# utility
func Clear_list(target_list:Node):
	for child in target_list.get_children(): 
		child.queue_free()
	
	
