extends CollisionObject2D

@export var chapter_name:String
@export var level_queue_path:String
@export var return_pos_offset : Vector2

func _ready() -> void:
	#pass
	if level_queue_path == "":
		level_queue_path = AppInfo.current_level

func Load_dialog_scene():
	AppInfo.Set_position_in_level(position + return_pos_offset)
	AppInfo.current_chapter = chapter_name
	AppInfo.level_queue = level_queue_path
	get_tree().change_scene_to_file(AppInfo.story_scene)

func _on_area_entered(_area: Area2D) -> void:
	call_deferred("Load_dialog_scene")


#func _on_child_entered_tree(node: Node) -> void:
	#if level_queue_path == "":
		#level_queue_path = AppInfo.current_level
