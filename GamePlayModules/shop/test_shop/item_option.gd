extends Button
@onready var atk_name_label: Label = $item_option/atk_name_label
@onready var damage_type_label: Label = $item_option/damage_type_label
@onready var damage_label: Label = $item_option/damage_label
@onready var price_label: Label = $item_option/price_label
@onready var quantity: Label = $item_option/Quantity

var item_info

func Set_up_option(new_item):
	item_info = new_item
	atk_name_label.text = new_item["name"]
	damage_type_label.text = new_item["type"]
	var new_dmg_value = new_item["damage"]
	if new_dmg_value < 0:
		new_dmg_value = -1 * new_dmg_value
	damage_label.text = str(new_dmg_value)
	price_label.text = str(new_item["price"])
	var inventory = AppInfo.save_file_json["item_inventory"]
	var item_key = new_item["name"]
	var amount = int(inventory[item_key] if inventory.has(item_key) else 0)
	var stack_cap = int(AppInfo.item_info_json[item_info["name"]]["stack_cap"])
	quantity.text =  str(amount) + " / " + str(stack_cap)


func Buy_item():
	if not AppInfo.Check_currency_amount(item_info["price"]):
		return
	if not AppInfo.Check_item_stack(item_info["name"]):
		#print(item_info["name"], " is already at max stack")
		return
	AppInfo.Update_player_currency(item_info["price"] * -1)
	AppInfo.Get_item(item_info["name"])
	SignalsResource.refresh_item_list.emit()

func Sell_item():
	var inventory = AppInfo.save_file_json["item_inventory"]
	if not inventory.has(item_info["name"]) or inventory[item_info["name"]] <= 0:
		#print("No ", item_info["name"], " to sell")
		return
	var sell_price = int(item_info["price"] * 0.5)  # 50% of buy price
	AppInfo.Update_player_currency(sell_price)
	AppInfo.Remove_item(item_info["name"])
	SignalsResource.refresh_item_list.emit()

func _on_button_button_up() -> void:
	Buy_item()

func _on_sell_button_button_up() -> void:
	Sell_item()
