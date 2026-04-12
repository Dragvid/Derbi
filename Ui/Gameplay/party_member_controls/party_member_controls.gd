extends Control

#@export var char_name : String
#@export var total_health : int
var char_name : String
var total_health : int
var player_id : int
var current_health : int
var attack_list

@onready var btn_block: Button = $VBoxContainer/Keyboard/Block
@onready var btn_interact: Button = $VBoxContainer/Keyboard/Interact
@onready var btn_attack: Button = $VBoxContainer/Keyboard/Attack
@onready var btn_inventory: Button = $VBoxContainer/Keyboard/Inventory
@onready var btn_escape: Button = $VBoxContainer/Keyboard/Escape
@onready var life_bar: ProgressBar = $VBoxContainer/lifeBar
@onready var atk_list_node: VBoxContainer = $atkListContainer/atkList
@onready var char_name_label: Label = $char_name_label

func _ready() -> void:
	btn_attack.grab_focus()
	

func set_up_player(new_name:String = "[missing]", new_life_total:int=100, new_attacks = [], new_player_id:int=0):
	char_name_label.text = new_name
	char_name = new_name
	player_id = new_player_id
	attack_list = new_attacks
	#health
	total_health = new_life_total
	current_health = total_health
	life_bar.max_value = total_health
	update_lifebar(current_health)

func update_lifebar(updated_life):
	life_bar.value=updated_life

func load_atk_list():
	pass

 
func _on_attack_button_up() -> void:
	atk_list_node.get_parent().visible = true

func _on_leave_atk_list_button_up() -> void:
	atk_list_node.get_parent().visible = false
