extends Control
@onready var btn_block: Button = $VBoxContainer/Keyboard/Block
@onready var btn_interact: Button = $VBoxContainer/Keyboard/Interact
@onready var btn_attack: Button = $VBoxContainer/Keyboard/Attack
@onready var btn_inventory: Button = $VBoxContainer/Keyboard/Inventory
@onready var btn_escape: Button = $VBoxContainer/Keyboard/Escape

func _ready() -> void:
	btn_attack.grab_focus()
