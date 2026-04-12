extends Control

@export var party_member_interface : PackedScene
@onready var player_interface: HBoxContainer = $Player_interface
var party_info = AppInfo.party_info_json
var currentTurn = 0

func _ready() -> void:
	#print(party_info)
	load_party_members()

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
