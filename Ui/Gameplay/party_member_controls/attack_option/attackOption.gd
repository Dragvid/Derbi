extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var description_label: Label = $atk_description/description
var play_area_manager
var party_member_manager

func set_information(new_text:String, new_module_manager):
	description_label.text = new_text
	play_area_manager = new_module_manager
	#print("play_area_manager: ",play_area_manager.name)

func _on_focus_entered() -> void:
	animation_player.play("display_info")

func _on_focus_exited() -> void:
	animation_player.play_backwards("display_info")

func _on_mouse_entered() -> void:
	animation_player.play("display_info")

func _on_mouse_exited() -> void:
	animation_player.play_backwards("display_info")

var module_manager = null
func _on_button_up() -> void:
	#get the target
	if module_manager == null:
		module_manager = GeneralToolsStatic.get_right_parent_node("BattleScreen",self)
	#if party_member_manager == null:
		#party_member_manager = GeneralToolsStatic.get_right_parent_node("party_member",self)
	module_manager.receive_current_attack(play_area_manager, self.text)
	#module_manager.enter_target_selection(true)
	module_manager.toggle_target_selection(true)
	#queue the attack
	#disable actions
	#play_area_manager.option_picked()
	#pass # Replace with function body.
