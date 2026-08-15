extends Control

@export var first_chapter : String
@export var first_level_scene : PackedScene

func Load_new_game():
	AppInfo.Reset_save_file()
	AppInfo.current_chapter = first_chapter
	AppInfo.level_queue = first_level_scene.resource_path
	get_tree().change_scene_to_file(AppInfo.story_scene)

func _on_new_game_button_button_up() -> void:
	Load_new_game()


func _on_continue_button_button_up() -> void:
	get_tree().change_scene_to_file(AppInfo.save_file_json["current_level"])
