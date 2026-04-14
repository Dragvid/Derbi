extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var description_label: Label = $atk_description/description

func set_information(new_text:String):
	description_label.text = new_text

func _on_focus_entered() -> void:
	animation_player.play("display_info")

func _on_focus_exited() -> void:
	animation_player.play_backwards("display_info")

func _on_mouse_entered() -> void:
	animation_player.play("display_info")

func _on_mouse_exited() -> void:
	animation_player.play_backwards("display_info")
