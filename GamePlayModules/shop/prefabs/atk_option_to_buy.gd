extends HBoxContainer
@onready var atk_name_label: Label = $atk_name_label
@onready var damage_type_label: Label = $damage_type_label
@onready var damage_label: Label = $damage_label
@onready var price_label: Label = $price_label

func Set_up_option(new_attack):
	atk_name_label.text = new_attack["name"]
	damage_type_label.text = new_attack["type"]
	var new_dmg_value = new_attack["damage"] 
	if new_dmg_value < 0:
		new_dmg_value = -1 * new_dmg_value
	damage_label.text = str(new_dmg_value)
	price_label.text = str(new_attack["price"])
