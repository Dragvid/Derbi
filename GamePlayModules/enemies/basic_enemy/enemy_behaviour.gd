extends Button

#@export var enemy_type : String

@onready var sprite: TextureRect = $TextureRect

var rng = RandomNumberGenerator.new()

#var enemy_type : String
var enemy_info

#func get_enemy_info():
	#if AppInfo.enemy_info_json.has(enemy_type):
		#enemy_info = AppInfo.attack_info_json[enemy_type]
	#else:
		#print("enemy named ",enemy_type," was not on the list")

func load_info(new_enemy_info):
	
	#add information
	#get_enemy_info() 
	enemy_info = new_enemy_info
	sprite.texture = load(enemy_info.sprite_path)
	#for testing
	#pick_attack()

#func _ready():
	

func pick_action():
	# Choose if you want to block or attack
	rng.randomize()
	var my_random_number = rng.randi_range(0, 100)
	if my_random_number < enemy_info.agressiveness:
		pick_attack()
	else:
		#block
		pass

func pick_attack():
	rng.randomize()
	var atk_option_id = rng.randi_range(0, enemy_info.attacks.size())
	print(enemy_info.attacks[atk_option_id])
	
