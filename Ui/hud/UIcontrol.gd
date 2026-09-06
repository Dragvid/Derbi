extends CanvasLayer

func _ready():
	# reset joystick to neutral
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("up")
	Input.action_release("down")
