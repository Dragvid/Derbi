extends Button

@onready var item_name: Label = $HBoxContainer/item_name
@onready var item_quant: Label = $HBoxContainer/item_quant

func Write_info(new_item_name, new_item_quant):
	item_name.text = new_item_name
	item_quant.text = new_item_quant
