extends Control

@export var party_member_interface : PackedScene
@onready var enemies_box: HBoxContainer = $Enemies

@onready var player_interface: HBoxContainer = $Player_interface
var party_info = AppInfo.party_info_json
var currentTurn = 0

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
			var unit_scene = GeneralToolsStatic.instantiate_scene(unit_info.scene_path,enemies_box)
			unit_scene.call_deferred("load_info",unit_info)
	else:#planned encounter
		pass

func load_party_members():
	var cur_player_id = 1
	for member in AppInfo.party_members:
		if party_info.has(member):
			var member_data = party_info[member]
			var member_ui = GeneralToolsStatic.instantiate_scene(party_member_interface.resource_path,player_interface)
			member_ui.call_deferred("set_up_player",member, member_data.total_life, member_data.attacks, cur_player_id)
			cur_player_id += 1 

func change_turn():
	currentTurn += 1
