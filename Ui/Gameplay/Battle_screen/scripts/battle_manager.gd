extends Control

@export var party_member_interface : PackedScene
@onready var enemies_box: HBoxContainer = $Enemies

@onready var player_interface: HBoxContainer = $Player_interface
var party_info = AppInfo.party_info_json
var turn_player = true
var ally_pick:bool = false
#attack processing
var current_attack : Dictionary = {
	"attacker"=null,
	"target"=null,
	"attack_name"=null
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
	#else:#planned encounter
		#pass

func load_party_members():
	var cur_player_id = 1
	for member in AppInfo.party_members:
		if party_info.has(member):
			var member_data = party_info[member]
			var member_ui = GeneralToolsStatic.instantiate_scene(party_member_interface.resource_path,player_interface)
			member_ui.call_deferred("set_up_player", self, member_data, member,  cur_player_id)
			cur_player_id += 1 

func toggle_target_selection(target_is_oponent:bool=true, enter:bool=true):
	if current_attack.attack_name!=null:
		var atk_info = AppInfo.attack_info_json[current_attack.attack_name]
		match atk_info.target:
			"opposition":
				ally_pick = false
				target_is_oponent = true
			"ally":
				ally_pick = true
				target_is_oponent = false
	if target_is_oponent:
		for enemy in enemies_box.get_children():
			enemy.disabled = !enter
	else:
		for party_member in player_interface.get_children():
			party_member.pick_ally_mode(true)

func check_turn_end():
	var turn_end = true
	var turn_group
	if turn_player:
		turn_group = get_active_party_members()
	else:
		turn_group = enemies_box.get_children()
	for member in turn_group:#check if it is the end of the turn
		if !member.state_current in [AppInfo.states.recovery,AppInfo.states.blocking]:
			#print(member.name, " is blocking the turn change, it is in: ", member.state_current)
			turn_end = false
	#print("turn_end: ",turn_end)
	if turn_end:
		change_turn()
func receive_current_attack(new_attacker,new_attack_name):
	current_attack.attacker = new_attacker
	current_attack.attack_name = new_attack_name
func receive_current_attack_target_choice(target_unit):
	# 1. Check if the dictionary is null or empty
	if current_attack == null or current_attack.is_empty():
		print("Warning: Attempted to set target, but current_attack is empty.")
		return # Stop the function here
	# 2. Check for specific required keys to be safe
	if not current_attack.has("attacker") or not current_attack.has("attack_name"):
		print("Warning: current_attack is missing required keys.")
		return
	# Proceed with logic safely
	current_attack.target = target_unit
	if current_attack.attacker != null and current_attack.attack_name != null:
		attack_process()
	if ally_pick:
		ally_pick = false
		for party_member in player_interface.get_children():
			party_member.pick_ally_mode(false)
	if turn_player:
		check_turn_end()
#apply damage
func attack_process():
	#get attack info
	var atk_info = AppInfo.attack_info_json[current_attack.attack_name]
	if randi_range(0,100) < atk_info.hit_rate:
		var final_damage = atk_info.damage
		if randi_range(0,100) < atk_info.crit_rate:
			final_damage = final_damage * AppInfo.crit_multiplier
		current_attack.target.update_life(final_damage)
	#else:
		#print("Miss")
	if turn_player:
		current_attack.attacker.option_picked()
	clean_current_atk()

func clean_current_atk():
	toggle_target_selection(true,false)
	current_attack.attacker = null
	current_attack.target = null
	current_attack.attack_name = null

func change_turn():
	turn_player = !turn_player
	await get_tree().create_timer(1).timeout
	if !turn_player:
		enemy_turn()
	else:
		for party_member in player_interface.get_children():
			party_member.turn_reset()

func enemy_turn():
	for enemy in enemies_box.get_children():
		enemy.state_current = AppInfo.states.idle
	for enemy in enemies_box.get_children():
		receive_current_attack(enemy,enemy.pick_attack())
		var valid_targets = get_active_party_members()
		receive_current_attack_target_choice(valid_targets.pick_random())
		await get_tree().create_timer(1).timeout
	change_turn()

func get_active_party_members() -> Array:
	return player_interface.get_children().filter(
		func(member): return member.state_current != AppInfo.states.defeated
	)

func is_action_pending() -> bool:
	# If the dictionary is empty, there is definitely no action pending
	if current_attack.is_empty():
		return false
	# We assume no action is pending until we find a non-null value
	for key in current_attack.keys():
		if current_attack[key] != null:
			# We found data! That means an action is in progress.
			print("Pending action found in key: ", key)
			return true 
			
	return false

func run_away(escape_chance:float):
	if randf() < escape_chance:
		print("Run away.")
		#escape to the combat to world scene
		pass
	else:
		print("Escape failed.")

func has_battle_ended():
	if enemies_box.get_children().size() == 0:
		print("Player wins")
	var active_party_members = get_active_party_members()
	if active_party_members.size()==0:
		print("Enemies won")
