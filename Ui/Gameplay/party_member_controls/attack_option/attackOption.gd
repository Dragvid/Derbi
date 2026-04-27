extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var description_label: Label = $atk_description/description
var play_area_manager

func set_information(new_text:String, module_manager):
	description_label.text = new_text
	play_area_manager = module_manager

func _on_focus_entered() -> void:
	animation_player.play("display_info")

func _on_focus_exited() -> void:
	animation_player.play_backwards("display_info")

func _on_mouse_entered() -> void:
	animation_player.play("display_info")

func _on_mouse_exited() -> void:
	animation_player.play_backwards("display_info")


func _on_button_up() -> void:
	#get the target
	var module_manager = GeneralToolsStatic.get_right_parent_node("BattleScreen",self)
	print("Module manager name: ", module_manager.name)
	module_manager.enter_target_selection(true)
	#queue the attack
	#disable actions
	#play_area_manager.option_picked()
	#pass # Replace with function body.
