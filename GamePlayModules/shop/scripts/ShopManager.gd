extends Control

@onready var shop_stock_container: VBoxContainer = $HBoxContainer/shopOptions/shopStock/shopStockContainer

@export var shop_name:String
@export var attack_line: PackedScene

func _ready() -> void:
	Load_shop()

func Load_shop():
	for attack in AppInfo.attack_info_json.values():
		if shop_name in attack["shop"]:
			var instance = GeneralToolsStatic.instantiate_scene(attack_line.resource_path, shop_stock_container)
			instance.call_deferred("Set_up_option",attack)
