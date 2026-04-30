class_name AppInfo

static var score : int
static var app_cleared = false
static var highscore : int
static var new_highscore : bool = false

static var crit_multiplier = 1.5

enum states {idle,stun,blocking,recovery}

static var party_members = ["Alex","Pedro"]
static var party_info_json = GeneralToolsStatic.get_dictionary_from_json("res://resources/party_info.json")
static var attack_info_json = GeneralToolsStatic.get_dictionary_from_json("res://resources/attack_list.json")
static var enemy_info_json = GeneralToolsStatic.get_dictionary_from_json("res://resources/enemy_info.json")


static func clear_app_info():#At the end the game
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

static func update_score(new_score:int):
	score += new_score

static func retrive_attack_info(atk_name):
	if attack_info_json.has(atk_name):
		var atk_info = AppInfo.attack_info_json[atk_name]
		return atk_info
	else:
		print("atk named ",atk_name," was not found in the list")
