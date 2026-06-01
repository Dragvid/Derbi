extends Node2D

@onready var player_avatar: CharacterBody2D = $player_avatar
var inicial_position

func _ready() -> void:
	inicial_position = player_avatar.position
	
	if AppInfo.last_battle_result == AppInfo.result_of_battle.win or AppInfo.last_battle_result == AppInfo.result_of_battle.escape:
		AppInfo.last_battle_result = null
		disable_defeated_encounters(AppInfo.defeated_encounters)
	if AppInfo.position_in_level != Vector2.ZERO:
		print("set the saved value")
		player_avatar.position = AppInfo.position_in_level
	else :
		print("set new position")
		AppInfo.Set_position_in_level(player_avatar.position)

func disable_defeated_encounters(node_paths: Array):
	for path in node_paths:
		var node = get_node_or_null(path)
		if node:
			node.queue_free()
		else:
			print("Node not found: ", path)
