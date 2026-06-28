extends Button

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var description_label: Label = $atk_description/description

@onready var item_name_label: Label = $HBoxContainer/itemName
@onready var item_quantity_label: Label = $HBoxContainer/itemQuantity

var play_area_manager

func _ready() -> void:
	SignalsResource.refresh_item_list.connect(Update_information)

func set_information(new_name,new_item_quant,new_text:String, new_module_manager):
	item_name_label.text = str(new_name)
	item_quantity_label.text = str(int(new_item_quant))
	description_label.text = new_text
	play_area_manager = new_module_manager
	#print("play_area_manager: ",play_area_manager.name)

func Update_information():
	var inventory = AppInfo.save_file_json.item_inventory
	if inventory.has(item_name_label.text):
		var item_quant = inventory[item_name_label.text]
		item_quantity_label.text = str(int(item_quant))
	else:
		queue_free()
		

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
	if battle_manager == null:
		battle_manager = GeneralToolsStatic.get_right_parent_node("BattleScreen", self)
	if battle_manager.is_action_pending():
		return
	var item_info = AppInfo.item_info_json[item_name_label.text]
	battle_manager.receive_current_item(play_area_manager, item_info["name"])
	AppInfo.Remove_item(item_info["name"])
	#decrement_quantity()
	SignalsResource.refresh_item_list.emit()
	battle_manager.toggle_target_selection()
