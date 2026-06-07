extends Button
@onready var atk_name_label: Label = $atk_option/atk_name_label
@onready var damage_type_label: Label = $atk_option/damage_type_label
@onready var damage_label: Label = $atk_option/damage_label
@onready var price_label: Label = $atk_option/price_label
@onready var buy_button: Button = $atk_option/Button

var atk_info

func Set_up_option(new_attack,owned = false):
	atk_info = new_attack
	atk_name_label.text = new_attack["name"]
	damage_type_label.text = new_attack["type"]
	var new_dmg_value = new_attack["damage"] 
	if new_dmg_value < 0:
		new_dmg_value = -1 * new_dmg_value
	damage_label.text = str(new_dmg_value)
	price_label.text = str(new_attack["price"])
	if owned:
		buy_button.visible = false
		
func Buy_attack():
	if AppInfo.Check_currency_amount(atk_info["price"]):
		#AppInfo.save_file_json[""]
		AppInfo.Update_player_currency(atk_info["price"]*-1)
		AppInfo.Unlock_Attack(atk_info["name"])
		SignalsResource.refresh_atk_list.emit()


func _on_button_button_up() -> void:
	Buy_attack()
