extends Area2D

func _on_area_entered(_area: Area2D) -> void:
	call_deferred("Go_to_combat_scene")

func Go_to_combat_scene():
	AppInfo.Set_position_in_level(position)
	AppInfo.enemy_last_battle = get_path()
	get_tree().change_scene_to_file(AppInfo.battle_scene)
