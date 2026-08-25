extends Area2D

@export var enemy_formation_size : int = 4
@export var encounter_background_path : String
func _on_area_entered(_area: Area2D) -> void:
	call_deferred("Go_to_combat_scene")

func Go_to_combat_scene():
	#AppInfo.current_enemy_formation_size = enemy_formation_size
	AppInfo.current_combat_parameters.enemy_formation_size = enemy_formation_size
	AppInfo.current_combat_parameters.background_path = encounter_background_path
	AppInfo.Set_position_in_level(position)
	AppInfo.enemy_last_battle = get_path()
	get_tree().change_scene_to_file(AppInfo.battle_scene)
