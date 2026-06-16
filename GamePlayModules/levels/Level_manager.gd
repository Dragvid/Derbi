extends Node2D

@onready var player_avatar: CharacterBody2D = $player_avatar
var inicial_position

func _ready() -> void:
	inicial_position = player_avatar.position
	
	if AppInfo.last_reason_to_return == AppInfo.reason_to_return.win or AppInfo.last_reason_to_return == AppInfo.reason_to_return.escape or AppInfo.last_reason_to_return == AppInfo.reason_to_return.shop:
		disable_defeated_encounters(AppInfo.defeated_encounters)
		
	if AppInfo.last_reason_to_return == AppInfo.reason_to_return.lose or AppInfo.last_reason_to_return == AppInfo.reason_to_return.escape:
		player_avatar.position = inicial_position
	else:
		if AppInfo.position_in_level != Vector2.ZERO:
			print("set the saved value")
			player_avatar.position = AppInfo.position_in_level
		else :
			print("set new position")
			AppInfo.Set_position_in_level(player_avatar.position)
	AppInfo.last_reason_to_return = null

func disable_defeated_encounters(node_paths: Array):
	for path in node_paths:
		var node = get_node_or_null(path)
		if node:
			node.queue_free()
		else:
			print("Node not found: ", path)
