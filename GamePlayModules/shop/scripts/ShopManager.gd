extends Control
@onready var shop_stock_container: VBoxContainer = $HBoxContainer/shopOptions/VBoxContainer/shopAtkStock/shopStockContainer
@onready var shop_item_container: VBoxContainer = $HBoxContainer/shopOptions/VBoxContainer/shopItemStock/shopStockContainer
@onready var players_money: Label = $HBoxContainer/Dead_area/VBoxContainer/players_money
@onready var description_label: Label = $HBoxContainer/Dead_area/VBoxContainer/description_area/description_label
@onready var atacks_tab: Button = $HBoxContainer/shopOptions/VBoxContainer/tabs/atacks
@onready var items_tab: Button = $HBoxContainer/shopOptions/VBoxContainer/tabs/Items
@onready var shop_atk_stock = $HBoxContainer/shopOptions/VBoxContainer/shopAtkStock
@onready var shop_item_stock = $HBoxContainer/shopOptions/VBoxContainer/shopItemStock

@export var shop_name: String
@export var attack_line: PackedScene
@export var item_line: PackedScene

func _ready() -> void:
	update_player_currency_label()
	_on_atacks_button_up()  # set default tab visibility first
	Load_shop()
	SignalsResource.refresh_atk_list.connect(Load_shop)
	SignalsResource.refresh_item_list.connect(Load_shop)

func Load_shop():
	Load_attack_shop()
	Load_item_shop()
	update_player_currency_label()

func update_player_currency_label():
	players_money.text = str(AppInfo.save_file_json["currency"], " eur")

func clear_list(list_to_clear):
	for child in list_to_clear.get_children():
		if child is Button:
			child.queue_free()

func Load_attack_shop():
	clear_list(shop_stock_container)
	for attack in AppInfo.attack_info_json.values():
		var already_owned = attack["name"] in AppInfo.save_file_json["unlocked_moves"]
		#print("checking: ", attack["name"], " | owned: ", already_owned, " | shop match: ", shop_name in attack["shop"])
		if shop_name in attack["shop"] and not already_owned:
			var instance: Button = GeneralToolsStatic.instantiate_scene(attack_line.resource_path, shop_stock_container)
			instance.call_deferred("Set_up_option", attack)
			instance.mouse_entered.connect(_on_option_hovered.bind(attack["description"]))
			instance.mouse_exited.connect(_on_option_unhovered)

func Load_item_shop():
	clear_list(shop_item_container)
	for item in AppInfo.item_info_json.values():
		if shop_name in item["shop"]:
			var instance: Button = GeneralToolsStatic.instantiate_scene(item_line.resource_path, shop_item_container)
			instance.call_deferred("Set_up_option", item)
			instance.mouse_entered.connect(_on_option_hovered.bind(item["description"]))
			instance.mouse_exited.connect(_on_option_unhovered)

func _on_option_hovered(description: String) -> void:
	description_label.get_parent().visible = true
	description_label.text = description

func _on_option_unhovered() -> void:
	description_label.get_parent().visible = false

func Back_to_level():
	get_tree().change_scene_to_file(AppInfo.current_level)

func _on_leave_shop_button_up() -> void:
	Back_to_level()

func _on_atacks_button_up() -> void:
	shop_atk_stock.visible = true
	shop_item_stock.visible = false

func _on_items_button_up() -> void:
	shop_atk_stock.visible = false
	shop_item_stock.visible = true
