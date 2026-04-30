extends Control

@export var party_member_interface : PackedScene
@onready var enemies_box: HBoxContainer = $Enemies

@onready var player_interface: HBoxContainer = $Player_interface
var party_info = AppInfo.party_info_json
var turn_player = true

#attack processing
var current_attack : Dictionary = {
	"attacker":Node,
	"target":Node,
	"attack_name":""
}


var rng = RandomNumberGenerator.new()

func _ready() -> void:
	load_party_members()
	load_enemies()

func load_enemies(enemy_list=[]):
	if enemy_list.is_empty():#random encounter
		var enemy_roster = AppInfo.enemy_info_json.keys()
		#random enemy number
		rng.randomize()
		var formation_size = rng.randi_range(1,4)
		#pick formation
		for i in range(0, formation_size):
			var formation_unit = enemy_roster.pick_random()
			#get the information and check if the scene is valid
			var unit_info = AppInfo.enemy_info_json[formation_unit]
			#instance scene
			var unit_scene:Node = GeneralToolsStatic.instantiate_scene(unit_info.scene_path,enemies_box)
			unit_scene.button_up.connect(receive_current_attack_target_choice.bind(unit_scene))
			unit_scene.call_deferred("load_info",unit_info,self)
	else:#planned encounter
		pass



func load_party_members():
	var cur_player_id = 1
	for member in AppInfo.party_members:
		if party_info.has(member):
			var member_data = party_info[member]
			var member_ui = GeneralToolsStatic.instantiate_scene(party_member_interface.resource_path,player_interface)
			member_ui.call_deferred("set_up_player", self, member_data, member,  cur_player_id)
			cur_player_id += 1 

func enter_target_selection(target_is_oponent:bool=true):
	if target_is_oponent:
		for enemy in enemies_box.get_children():
			enemy.disabled = false

func check_turn_end():
	var turn_end = true
	var turn_group
	if turn_player:
		turn_group = player_interface.get_children()
	else:
		turn_group = enemies_box.get_children()
	for member in turn_group:#check if it is the end of the turn
		if member.state_current != AppInfo.states.recovery:
			turn_end = false
	if turn_end:
		change_turn()
func receive_current_attack(new_attacker,new_attack_name):
	current_attack.attacker = new_attacker
	current_attack.attack_name = new_attack_name
func receive_current_attack_target_choice(target_unit):#receive target choice
	current_attack.target = target_unit
	if current_attack.attacker != null and current_attack.attack_name != null:
		attack_process()
	check_turn_end()
#apply damage
func attack_process():
	#get attack info
	var atk_info = AppInfo.attack_info_json[current_attack.attack_name]
	#print("attack process, atk info: ",atk_info)
	if randi_range(0,100) < atk_info.hit_rate:
		var final_damage = atk_info.damage
		if randi_range(0,100) < atk_info.crit_rate:
			final_damage = final_damage * AppInfo.crit_multiplier
		current_attack.target.update_life(final_damage)
	if turn_player:
		current_attack.attacker.option_picked()

func change_turn():
	print("change turn")
	turn_player = !turn_player
	if !turn_player:
		enemy_turn()
	else:
		for party_member in player_interface.get_children():
			party_member.turn_reset()


func enemy_turn():
	for enemy in enemies_box.get_children():
		#print(enemy.pick_attack())
		print("enemy attack: ",enemy.name)
		receive_current_attack(enemy,enemy.pick_attack())
		receive_current_attack_target_choice(player_interface.get_children().pick_random())
		await get_tree().create_timer(1).timeout
	change_turn()

func run_away(escape_chance:float):
	if randf() < escape_chance:
		print("Run away.")
		#escape to the combat to world scene
		pass
	else:
		print("Escape failed.")
