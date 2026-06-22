extends Button

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var description_label: Label = $atk_description/description

@onready var item_name_label: Label = $HBoxContainer/itemName
@onready var item_quantity_label: Label = $HBoxContainer/itemQuantity

var play_area_manager

func set_information(new_name,new_item_quant,new_text:String, new_module_manager):
	item_name_label.text = str(new_name)
	item_quantity_label.text = str(int(new_item_quant))
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

#var battle_manager = null
#var player_manager = null
#func _on_button_up() -> void:
	##get the target
	#if battle_manager == null:
			#battle_manager = GeneralToolsStatic.get_right_parent_node("BattleScreen",self)
	##if player_manager == null:
			##battle_manager = GeneralToolsStatic.get_right_parent_node("BattleScreen",self)
	#if play_area_manager.try_spend_stamina(AppInfo.Retrive_attack_info(self.text).cost):
		#battle_manager.receive_current_attack(play_area_manager, self.text)
		#battle_manager.toggle_target_selection()
		#play_area_manager.Attack_list_disabled_state(true)
