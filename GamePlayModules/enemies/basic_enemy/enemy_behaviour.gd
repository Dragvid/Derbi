extends Button

#@export var enemy_type : String

@onready var sprite: TextureRect = $TextureRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var rng = RandomNumberGenerator.new()
var current_health
var enemy_info
var module_manager
var state_current = AppInfo.states.idle

#func get_enemy_info():
	#if AppInfo.enemy_info_json.has(enemy_type):
		#enemy_info = AppInfo.attack_info_json[enemy_type]
	#else:
		#print("enemy named ",enemy_type," was not on the list")

func load_info(new_enemy_info,new_module_manager):
	module_manager = new_module_manager
	#add information
	enemy_info = new_enemy_info
	sprite.texture = load(enemy_info.sprite_path)
	current_health = enemy_info.total_life

func pick_action():
	# Choose if you want to block or attack
	rng.randomize()
	var my_random_number = rng.randi_range(0, 100)
	if my_random_number < enemy_info.agressiveness:
		pick_attack()
	else:
		print("enemy blocked")
		state_current = AppInfo.states.blocking

func update_life(updated_life):
	var damage = updated_life 
	if damage < 0:
		print("Damage animation on enemy")
		animation_player.play("hurt")
		if state_current == AppInfo.states.blocking:#damage
			damage = damage * enemy_info.block_dmg_resistance
	current_health += damage 
	if current_health <= 0:
		print(name," Died")
		queue_free()
	print("damage recieved: ",damage,"/ current life: ",current_health)

func pick_attack():
	animation_player.play("attack")
	state_current = AppInfo.states.recovery
	return enemy_info.attacks.pick_random()
	
