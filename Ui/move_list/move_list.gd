extends Control
@onready var menu_container: VBoxContainer = $HBoxContainer/ScrollContainer/list
const ATTACK_LIST_path = "res://resources/attack_list.json"
var option_button_path = "res://Ui/move_list/Move_option/Move_option.tscn"
func _ready() -> void:
	load_list(GeneralToolsStatic.get_dictionary_from_json(ATTACK_LIST_path))
	

func load_list(data: Dictionary):
	# 1. Clear old buttons
	for child in menu_container.get_children():
		child.queue_free()

	# 2. Loop through keys
	for attack_key in data.keys():
		var attack_info = data[attack_key]
		var new_button = GeneralToolsStatic.instantiate_scene(option_button_path, menu_container)
		if new_button.is_node_ready():
			new_button.write_info(attack_info["Name"])
		else:
			new_button.call_deferred("write_info", attack_info["name"])
		new_button.connect("pressed",display_attack_info.bind(attack_info["name"]))

func display_attack_info(atk_name=""):
	print("click ", atk_name)
