extends Area2D
@export var level_queue_path:String

func Load_next_scene():
	AppInfo.last_reason_to_return = AppInfo.reason_to_return.first_time
	get_tree().change_scene_to_file(level_queue_path)


func _on_area_entered(_area: Area2D) -> void:
	call_deferred("Load_next_scene")
