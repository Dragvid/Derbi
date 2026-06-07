extends Control

@onready var shop_stock_container: VBoxContainer = $HBoxContainer/shopOptions/VBoxContainer/shopAtkStock/shopStockContainer
@onready var players_money: Label = $players_money
@onready var description_label: Label = $HBoxContainer/Dead_area/VBoxContainer/description_area/description_label

@export var shop_name:String
@export var attack_line: PackedScene


func _ready() -> void:
	update_player_currency_label()
	Load_shop()
	SignalsResource.refresh_atk_list.connect(Load_shop)

func Load_shop():
	Load_attack_shop()
	update_player_currency_label()

func update_player_currency_label():
	players_money.text = str(AppInfo.save_file_json["currency"]," eur")

func clear_list(list_to_clear):
	for child in list_to_clear.get_children():
		if child is Button:
			child.queue_free()

func Load_attack_shop():
	clear_list(shop_stock_container)
	for attack in AppInfo.attack_info_json.values():
		var already_owned = attack["name"] in AppInfo.save_file_json["unlocked_moves"]
		if shop_name in attack["shop"] and not already_owned:
			var instance:Button = GeneralToolsStatic.instantiate_scene(attack_line.resource_path, shop_stock_container)
			instance.call_deferred("Set_up_option", attack)
			instance.mouse_entered.connect(_on_option_hovered.bind(attack["description"]))
			instance.mouse_exited.connect(_on_option_unhovered)
			#instance.buy_button.pressed.connect(_buy_attack.bind(attack))

func _on_option_hovered(description: String) -> void:
	description_label.get_parent().visible = true
	description_label.text = description

func _on_option_unhovered() -> void:
	description_label.get_parent().visible = false

#func _buy_attack(attack):
	#if AppInfo.Check_currency_amount(attack["price"]):
		#AppInfo.Update_player_currency(attack["price"])
	
