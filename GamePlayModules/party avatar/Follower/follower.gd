extends CharacterBody2D

@export var follow_distance: float = 60.0   # how close they stay
@export var follow_speed: float = 200.0     # how fast they catch up
@export var catch_up_speed: float = 400.0  # faster speed when far behind

var target: Node2D = null
var position_history: Array = []
var history_length: int = 10  # how many frames of delay


func _ready() -> void:
	target = get_parent().get_node("player_avatar")  # adjust to your player node name

func _physics_process(delta: float) -> void:
	if target == null:
		return
	
	# record player position history
	position_history.append(target.global_position)
	if position_history.size() > history_length:
		position_history.pop_front()
	
	# follow a past position for the delay effect
	var follow_target = position_history[0]
	var distance = global_position.distance_to(follow_target)
	
	if distance > follow_distance:
		var direction = (follow_target - global_position).normalized()
		var speed = catch_up_speed if distance > follow_distance * 2 else follow_speed
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
