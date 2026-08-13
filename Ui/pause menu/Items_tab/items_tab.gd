extends Control

@export var item_option_scene : PackedScene

@onready var content: VBoxContainer = $ScrollContainer/content

var inventory : Dictionary

func _ready() -> void:
	inventory = AppInfo.save_file_json["item_inventory"]
	print(inventory)
	Fill_options()

func Fill_options():
	for item in inventory.keys():
		print(item)
		var item_button : Button = GeneralToolsStatic.instantiate_scene(item_option_scene.resource_path,content)
		var item_quant = int(inventory[item])
		item_button.call_deferred("Write_info", item, str(item_quant,"x"))
