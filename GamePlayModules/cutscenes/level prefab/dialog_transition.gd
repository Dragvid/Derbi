extends CollisionObject2D

@export var chapter_name:String
@export var return_pos_offset : Vector2

func Load_dialog_scene():
	AppInfo.Set_position_in_level(position + return_pos_offset)
	AppInfo.current_chapter = chapter_name
	get_tree().change_scene_to_file(AppInfo.story_scene)

func _on_area_entered(_area: Area2D) -> void:
	call_deferred("Load_dialog_scene")
