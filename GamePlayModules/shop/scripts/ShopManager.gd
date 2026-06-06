extends Control

@onready var shop_stock_container: VBoxContainer = $HBoxContainer/shopOptions/VBoxContainer/shopAtkStock/shopStockContainer
@onready var players_money: Label = $players_money
 
@export var shop_name:String
@export var attack_line: PackedScene

func _ready() -> void:
	update_player_currency_label()
	Load_shop()

func Load_shop():
	Load_attack_shop()

func update_player_currency_label():
	players_money.text = str(AppInfo.save_file_json["currency"]," eur")

func Load_attack_shop():
	for attack in AppInfo.attack_info_json.values():
		var already_owned = attack["name"] in AppInfo.save_file_json["unlocked_moves"]
		if shop_name in attack["shop"] and not already_owned:
			var instance = GeneralToolsStatic.instantiate_scene(attack_line.resource_path, shop_stock_container)
			instance.call_deferred("Set_up_option", attack)
