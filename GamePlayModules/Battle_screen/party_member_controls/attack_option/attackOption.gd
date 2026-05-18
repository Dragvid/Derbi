extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var description_label: Label = $atk_description/description
var play_area_manager

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

var battle_manager = null
func _on_button_up() -> void:
	if play_area_manager.try_spend_stamina(AppInfo.retrive_attack_info(self.text).cost):
		#get the target
		if battle_manager == null:
			battle_manager = GeneralToolsStatic.get_right_parent_node("BattleScreen",self)
		battle_manager.receive_current_attack(play_area_manager, self.text)
		battle_manager.toggle_target_selection()
