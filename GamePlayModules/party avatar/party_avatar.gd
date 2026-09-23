extends CharacterBody2D

@export var speed = 400
@export var partner_scene_path : String = ""


func instantiate_partner():
	GeneralToolsStatic.instantiate_scene(partner_scene_path,get_parent(),position)

func _ready() -> void:
	instantiate_partner()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()
