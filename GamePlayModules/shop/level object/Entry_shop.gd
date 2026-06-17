extends CollisionObject2D

@export var shop_name:String
@export var return_pos_offset : Vector2

func Load_shop_scene():
	AppInfo.Set_position_in_level(position + return_pos_offset)
	get_tree().change_scene_to_file(AppInfo.shop_scene)

func _on_area_entered(area: Area2D) -> void:
	call_deferred("Load_shop_scene")
