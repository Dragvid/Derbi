extends Control
@onready var menu_container: VBoxContainer = $HBoxContainer/ScrollContainer/list
const ATTACK_LIST_path = "res://resources/attack_list.json"
var option_button_path = "res://Ui/move_list/Move_option/Move_option.tscn"
func _ready() -> void:
	load_list(GeneralToolsStatic.get_dictionary_from_json(ATTACK_LIST_path))
	
@onready var label_atk_name: Label = $HBoxContainer/description/content/atkName
@onready var label_atk_hit_chance: Label = $HBoxContainer/description/content/HBoxContainer/atkHitChance
@onready var label_atk_dmg: Label = $HBoxContainer/description/content/HBoxContainer/atkDmg
@onready var label_atk_lvl_requirement: Label = $HBoxContainer/description/content/HBoxContainer2/atkLvlRequirement
@onready var label_atk_description: Label = $HBoxContainer/description/content/atkDescription



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
		new_button.connect("pressed",display_attack_info.bind(attack_info))

func display_attack_info(_atk_info):
	#print("click ", _atk_info)
	label_atk_name.text = _atk_info["name"]
	label_atk_dmg.text = str(_atk_info["damage"])
	label_atk_description.text = _atk_info["description"]
	label_atk_lvl_requirement.text = str(_atk_info["level_requirement"])
	label_atk_hit_chance.text = str(_atk_info["hit_rate"])
