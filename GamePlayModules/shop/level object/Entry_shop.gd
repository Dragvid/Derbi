extends CollisionObject2D

@export var shop_name:String

func Load_shop_scene():
	#AppInfo.Set_position_in_level(position)
	#AppInfo.enemy_last_battle = get_path()
	get_tree().change_scene_to_file(AppInfo.shop_scene)

func _on_area_entered(area: Area2D) -> void:
	call_deferred("Load_shop_scene")
