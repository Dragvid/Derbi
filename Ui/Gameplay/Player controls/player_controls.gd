extends Control

var player_id
var player_name
var current_health : int
@export var total_health : int

@onready var btn_block: Button = $VBoxContainer/Keyboard/Block
@onready var btn_interact: Button = $VBoxContainer/Keyboard/Interact
@onready var btn_attack: Button = $VBoxContainer/Keyboard/Attack
@onready var btn_inventory: Button = $VBoxContainer/Keyboard/Inventory
@onready var btn_escape: Button = $VBoxContainer/Keyboard/Escape
@onready var life_bar: ProgressBar = $VBoxContainer/lifeBar

func _ready() -> void:
	btn_attack.grab_focus()
	current_health = total_health
	life_bar.max_value = total_health
	update_lifebar(current_health)

func update_lifebar(updated_life):
	life_bar.value=updated_life
