extends Control

@export var attack_option_scene : PackedScene

var char_name : String
var total_health : int
var player_id : int
var current_health : int
var attack_list

@onready var btn_block: Button = $main_game/Keyboard/Block
@onready var btn_interact: Button = $main_game/Keyboard/Interact
@onready var btn_attack: Button = $main_game/Keyboard/Attack
@onready var btn_inventory: Button = $main_game/Keyboard/Inventory
@onready var btn_escape: Button = $main_game/Keyboard/Escape
@onready var life_bar: ProgressBar = $main_game/lifeBar
@onready var main_game: VBoxContainer = $main_game
@onready var atk_list_node: VBoxContainer = $atkListContainer/atkList
@onready var char_name_label: Label = $char_name_label

func _ready() -> void:
	btn_attack.grab_focus()
	

func set_up_player(new_name:String = "[missing]", new_life_total:int=100, new_attacks = [], new_player_id:int=0):
	char_name_label.text = new_name
	char_name = new_name
	player_id = new_player_id
	attack_list = new_attacks
	load_atk_list()
	#health
	total_health = new_life_total
	current_health = total_health
	life_bar.max_value = total_health
	update_lifebar(current_health)

func update_lifebar(updated_life):
	life_bar.value=updated_life

func load_atk_list():
	for atk in attack_list:
		if AppInfo.attack_info_json.has(atk):
			var atk_info = AppInfo.attack_info_json[atk]
			var atk_opt_instance = GeneralToolsStatic.instantiate_scene(attack_option_scene.resource_path,atk_list_node)
			atk_opt_instance.text = atk
			var text_to_add = str("Target: ",atk_info.target, " Cost: ",atk_info.cost,"\n ",atk_info.description)
			atk_opt_instance.call_deferred("set_information",text_to_add)
		else:
			print("atk named ",atk," was not found in the list")

func _on_attack_button_up() -> void:
	atk_list_node.get_parent().visible = true
	main_game.visible = false
	atk_list_node.get_child(0).grab_focus()

func _on_leave_atk_list_button_up() -> void:
	atk_list_node.get_parent().visible = false
	main_game.visible = true
