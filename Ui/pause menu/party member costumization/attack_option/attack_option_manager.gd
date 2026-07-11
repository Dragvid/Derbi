extends Button

@onready var name_label: Label = $HBoxContainer/Label
@onready var button: Button = $HBoxContainer/action_button

func Write_info(new_attack_name, purpose):
	name_label.text = new_attack_name
	button.text = purpose
