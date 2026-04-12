class_name AppInfo

static var score : int
static var app_cleared = false
static var highscore : int
static var new_highscore : bool = false

static var party_members = ["Alex","Pedro"]
static var party_info_json = GeneralToolsStatic.get_dictionary_from_json("res://resources/party_info.json")


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
	
