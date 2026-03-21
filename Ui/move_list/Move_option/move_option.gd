extends Control
@onready var move_name_label: Label = $move_name

var move_name = ""

func write_info(_name:String):
	move_name = _name
	move_name_label.text = move_name
