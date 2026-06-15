class_name AppInfo

#signal target_pick(target)


static var score : int
static var app_cleared = false
static var highscore : int
static var new_highscore : bool = false

static var crit_multiplier = 1.5

enum states {idle,stun,blocking,recovery,defeated}

enum reason_to_return{win,lose,escape,shop}
static var last_reason_to_return
static var enemy_last_battle

static var party_members = ["Alex","Pedro"]
static var party_info_json = GeneralToolsStatic.get_dictionary_from_json("res://resources/party_info.json")
static var attack_info_json = GeneralToolsStatic.get_dictionary_from_json("res://resources/attack_list.json")
static var enemy_info_json = GeneralToolsStatic.get_dictionary_from_json("res://resources/enemy_info.json")
static var item_info_json = GeneralToolsStatic.get_dictionary_from_json("res://resources/item_list.json")

static var save_file_json = GeneralToolsStatic.get_dictionary_from_json("res://resources/Player_Save.json")

static var battle_scene = "res://GamePlayModules/Battle_screen/Battle_screen.tscn"
static var current_level = "res://GamePlayModules/levels/test_level/test_level_scene.tscn"

static var position_in_level : Vector2

static var defeated_encounters = []

static func Set_position_in_level(new_position):
	position_in_level = new_position

static func Add_defeated_encounter():
	defeated_encounters.append(enemy_last_battle)

static func Clear_app_info():#At the end the game
	if app_cleared:
		return
	if score > SaveSystem.get_highscore():
		#print("New highscore")
		SaveSystem._write_save(
			{"highscore": score}
		)
		AppInfo.highscore = score
		new_highscore = true
	score = 0
	app_cleared = true	

static func Update_score(new_score:int):
	score += new_score

#static func Collect_item(new_item):
	#if item_info_json.has(new_item):
		#item_info_json["item_inventory"].append(new_item)
		#Save_file("res://resources/Player_Save.json",item_info_json)

static func Retrive_attack_info(atk_name):
	if attack_info_json.has(atk_name):
		var atk_info = AppInfo.attack_info_json[atk_name]
		return atk_info
	else:
		print("atk named ",atk_name," was not found in the list")

static func Update_player_currency(new_value):
	save_file_json["currency"] = save_file_json["currency"] + new_value
	Save_file("res://resources/Player_Save.json",save_file_json)

static func Save_file(file_path, dictionary):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(dictionary, "\t"))
	file.close()

static func Check_currency_amount(check_amount):
	var result : bool
	if save_file_json["currency"] >= check_amount:
		result = true
	else: 
		result = false
	return result

static func Unlock_Attack(new_attack_name:String):
	save_file_json["unlocked_moves"].append(new_attack_name)
	Save_file("res://resources/Player_Save.json",save_file_json)

static func Get_item(item_name: String):
	var inventory = save_file_json["item_inventory"]
	var item_data = item_info_json[item_name]
	var stack_cap = item_data["stack_cap"]
	if inventory.has(item_name):
		if inventory[item_name] < stack_cap:
			inventory[item_name] += 1
		else:
			print(item_name, " is already at max stack: ", stack_cap)
			return
	else:
		inventory[item_name] = 1
	Save_file("res://resources/Player_Save.json", save_file_json)

static func Check_item_stack(item_name: String) -> bool:
	var inventory = save_file_json["item_inventory"]
	var stack_cap = item_info_json[item_name]["stack_cap"]
	if inventory.has(item_name):
		return inventory[item_name] < stack_cap
	return true  # item not in inventory yet, safe to add
