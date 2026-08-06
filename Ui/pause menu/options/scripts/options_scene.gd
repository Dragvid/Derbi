extends Control
@onready var sound_tab: Control = $VBoxContainer/SoundTab
@onready var keys_tab: Control = $VBoxContainer/keysTab


func _on_sound_button_button_up() -> void:
	sound_tab.visible = true
	keys_tab.visible = false


func _on_controls_button_button_up() -> void:
	sound_tab.visible = false
	keys_tab.visible = true
