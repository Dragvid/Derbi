extends Area2D
@export var level_queue_path:String

func Load_next_scene():
	#AppInfo.Set_position_in_level(position + return_pos_offset)
	#AppInfo.current_chapter = chapter_name
	#AppInfo.level_queue = level_queue_path
	get_tree().change_scene_to_file(level_queue_path)


func _on_area_entered(_area: Area2D) -> void:
	call_deferred("Load_next_scene")
