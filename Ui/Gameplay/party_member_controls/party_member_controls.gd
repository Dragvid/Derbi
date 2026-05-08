extends Control

@export var attack_option_scene : PackedScene

var char_name : String
var total_health : int
var player_id : int
var current_health : int
var attack_list
var battle_manager
var state_current = AppInfo.states.idle 
var member_info

@onready var option_keyboard: GridContainer = $main_game/Keyboard
@onready var btn_block: Button = $main_game/Keyboard/Block
@onready var btn_interact: Button = $main_game/Keyboard/Interact
@onready var btn_attack: Button = $main_game/Keyboard/Attack
@onready var btn_inventory: Button = $main_game/Keyboard/Inventory
@onready var btn_escape: Button = $main_game/Keyboard/Escape
@onready var life_bar: ProgressBar = $main_game/lifeBar
@onready var main_game_node: VBoxContainer = $main_game
@onready var pick_button: Button = $pick_button
@onready var deathscreen: Control = $deathscreen

@onready var atk_list_node: VBoxContainer = $main_game/atkListContainer/atkList
@onready var char_name_label: Label = $char_name_label
@onready var action_picked: Control = $main_game/action_picked

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var char_portrait: TextureRect = $char_portrait


func _ready() -> void:
	btn_attack.grab_focus()

func set_up_player(manager, member_data, new_name:String = "[missing]", new_player_id:int=0):
	battle_manager = manager
	char_name_label.text = new_name
	char_name = new_name
	player_id = new_player_id
	attack_list = member_data.attacks
	load_atk_list()
	#health
	total_health = member_data.total_life
	current_health = total_health
	life_bar.max_value = total_health
	update_life(current_health)
	member_info = member_data
	char_portrait.texture = load(member_info.portrait_path)

func update_life(updated_life):
	var damage = updated_life 
	if damage < 0:
		animation_player.play("damage")
		if state_current == AppInfo.states.blocking:#damage
			damage = damage * member_info.block_dmg_resistance
	life_bar.value += damage 
	if life_bar.value<=0:#death
		die()
func die():
	battle_manager.has_battle_ended()
	state_current = AppInfo.states.defeated
	main_game_node.visible = false
	deathscreen.visible=true
	
func load_atk_list():
	for atk in attack_list:
		if AppInfo.attack_info_json.has(atk):
			var atk_info = AppInfo.attack_info_json[atk]
			var atk_opt_instance = GeneralToolsStatic.instantiate_scene(attack_option_scene.resource_path,atk_list_node)
			atk_opt_instance.text = atk
			var text_to_add = str("Target: ",atk_info.target, " Cost: ",atk_info.cost,"\n ",atk_info.description)
			atk_opt_instance.call_deferred("set_information", text_to_add, self)
		else:
			print("atk named ",atk," was not found in the list")

func option_picked():
	if state_current != AppInfo.states.blocking:
		state_current = AppInfo.states.recovery
	option_keyboard.visible = false
	atk_list_node.get_parent().visible = false
	action_picked.visible = true
	battle_manager.check_turn_end()

func turn_reset():
	if state_current != AppInfo.states.defeated:
		state_current = AppInfo.states.idle
	atk_list_node.get_parent().visible = false
	action_picked.visible = false
	option_keyboard.visible = true	

func pick_ally_mode(mode:bool):
	pick_button.visible = mode

func _on_attack_button_up() -> void:
	if battle_manager.is_action_pending():
		return
	atk_list_node.get_parent().visible = true
	option_keyboard.visible = false
	atk_list_node.get_child(0).grab_focus()

func _on_leave_atk_list_button_up() -> void:
	battle_manager.clean_current_atk()
	atk_list_node.get_parent().visible = false
	option_keyboard.visible = true

func _on_escape_button_up() -> void:
	if battle_manager.is_action_pending():
		return
	battle_manager.run_away(0.2)
	option_picked()

func _on_block_button_up() -> void:
	if battle_manager.is_action_pending():
		return
	state_current = AppInfo.states.blocking
	#change sprite
	option_picked()

func _on_pick_button_button_up() -> void:
	battle_manager.receive_current_attack_target_choice(self)
	pick_button.visible = false
