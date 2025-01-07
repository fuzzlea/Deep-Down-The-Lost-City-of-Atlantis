extends Node

signal LOAD_DATA
signal SAVE_DATA
signal DATA_SAVED

signal UPDATE_POSITION(pos : Vector2)

@export var COMPLETED_INIT_PROCESS = false

var db : SQLite

@export var Data : Dictionary = {
	"Relics": {
		
		"Pressure Gloves": [false, "res://Assets/Singles (Misc)/Collectibles/Relics/Pressure Gloves.png"],
		"Aqua Lobber": [false, "res://Assets/Singles (Misc)/Collectibles/Relics/Aqua Lobber.png"],
		"Golden Magnet": [false, "res://Assets/Singles (Misc)/Collectibles/Relics/Golden Magnet.png"],
		"Hydro Battery": [false, "res://Assets/Singles (Misc)/Collectibles/Relics/Hydro Battery.png"],
		"Poseidons Trident": [false, "res://Assets/Singles (Misc)/Collectibles/Relics/Poseidons Trident.png"],
		
	},
	"TutorialsCompleted": [
		
	],
	"CurrentPuzzle": 0,
	"Died": 0,
	"LastPosInMain": Vector2(249,708)
}

func _init(): 
	db = SQLite.new(); 
	db.path = "res://data.db"; 
	db.open_db(); 
	
	SAVE_DATA.connect(saveData)
	
	LOAD_DATA.connect(func():
		db.query("select * from player_data")
		if db.query_result == []:
			initDataTable()
		else:
			loadData()
	)

func loadSceneWithScreen(scenePath : String):
	
	var loadingScreen = preload("res://Scenes/UI/LoadingScreen.tscn")
	
	var newLoadingScreen = loadingScreen.instantiate()
	newLoadingScreen.nextScenePath = scenePath
	
	if newLoadingScreen: get_tree().get_root().add_child(newLoadingScreen)

func returnTFtoInt(b : bool):
	if b: return 1
	else: return 0

func returnInttoTF(i : int):
	if i == 1:
		return true
	elif i == 0:
		return false

func saveData():
	
	#inventory
	
	#player data
	
	db.update_rows("player_data", "id=1", {
		"current_puzzle": Data["CurrentPuzzle"],
		"died": Data["Died"],
		"last_pos_y": Data["LastPosInMain"].y,
		"last_pos_x": Data["LastPosInMain"].x,
		"completed_init": returnTFtoInt(COMPLETED_INIT_PROCESS)
		})
	
	#relics
	
	db.update_rows("relics", "name='Pressure Gloves'", {"owned": returnTFtoInt(Data["Relics"]["Pressure Gloves"][0])})
	db.update_rows("relics", "name='Aqua Lobber'", {"owned": returnTFtoInt(Data["Relics"]["Aqua Lobber"][0])})
	db.update_rows("relics", "name='Golden Magnet'", {"owned": returnTFtoInt(Data["Relics"]["Golden Magnet"][0])})
	db.update_rows("relics", "name='Hydro Battery'", {"owned": returnTFtoInt(Data["Relics"]["Hydro Battery"][0])})
	db.update_rows("relics", "name='Poseidons Trident'", {"owned": returnTFtoInt(Data["Relics"]["Poseidons Trident"][0])})
	
	#tutorials
	
	if not Data["TutorialsCompleted"].is_empty():
		for tut in Data["TutorialsCompleted"]:
			db.update_rows("tutorials", "name='" + tut + "'", {"completed": 1})

func loadData():
	
	#inventory
	
	#player data
	
	db.query("SELECT * FROM player_data;")
	var player_data = db.query_result
	
	Data["CurrentPuzzle"] = player_data[0]["current_puzzle"]
	Data["Died"] = player_data[0]["died"]
	Data["LastPosInMain"] = Vector2(player_data[0]["last_pos_x"], player_data[0]["last_pos_y"])
	COMPLETED_INIT_PROCESS = returnInttoTF(player_data[0]["completed_init"])
	
	#relics
	
	db.query("SELECT * FROM relics")
	var relic_data = db.query_result
	
	var namespaces = {}
	
	for table in relic_data:
		namespaces[table["name"]] = returnInttoTF(table["owned"])
	
	for relic in Data["Relics"]:
		Data["Relics"][relic][0] = namespaces[relic]
	
	#tutorials
	
	db.query("SELECT * FROM tutorials")
	var tut_data = db.query_result
	
	var tut_namespaces = {}
	
	for table in tut_data:
		tut_namespaces[table["name"]] = returnInttoTF(table["completed"])
	
	for tut in tut_namespaces:
		if tut_namespaces[tut] == true:
			Data["TutorialsCompleted"].append(tut)

func initDataTable():
	
	print("INIT DATA")
	
	var tutorialsTable = {
		"id" : {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"name" : {"data_type": "text", "primary_key": false, "not_null": true, "auto_increment": false},
		"completed" : {"data_type": "int", "primary_key": false, "not_null": true, "auto_increment": false},
	}
	
	db.create_table("tutorials", tutorialsTable)
	
	db.insert_row("tutorials", {"name": "BasicMovement", "completed": 0})
	db.insert_row("tutorials", {"name": "CrabsAndKelp", "completed": 0})
	db.insert_row("tutorials", {"name": "RelicTutorial", "completed": 0})
	
	var inventoryTable = {
		"id" : {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"name" : {"data_type": "text", "primary_key": false, "not_null": true, "auto_increment": false},
		"quantity" : {"data_type": "int", "primary_key": false, "not_null": true, "auto_increment": false},
	}
	
	db.create_table("inventory", inventoryTable)
	
	var relicsTable = {
		"id" : {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"name" : {"data_type": "text", "primary_key": false, "not_null": true, "auto_increment": false},
		"owned" : {"data_type": "int", "primary_key": false, "not_null": true, "auto_increment": false},
		"asset_location" : {"data_type": "text", "primary_key": false, "not_null": true, "auto_increment": false},
	}
	
	db.create_table("relics", relicsTable)
	
	db.insert_row("relics", {"name": "Pressure Gloves", "owned": 0, "asset_location": "res://Assets/Singles (Misc)/Collectibles/Relics/Pressure Gloves.png"})
	db.insert_row("relics", {"name": "Aqua Lobber", "owned": 0, "asset_location": "res://Assets/Singles (Misc)/Collectibles/Relics/Aqua Lobber.png"})
	db.insert_row("relics", {"name": "Golden Magnet", "owned": 0, "asset_location": "res://Assets/Singles (Misc)/Collectibles/Relics/Golden Magnet.png"})
	db.insert_row("relics", {"name": "Hydro Battery", "owned": 0, "asset_location": "res://Assets/Singles (Misc)/Collectibles/Relics/Hydro Battery.png"})
	db.insert_row("relics", {"name": "Poseidons Trident", "owned": 0, "asset_location": "res://Assets/Singles (Misc)/Collectibles/Relics/Poseidons Trident.png"})
	
	var playerTable = {
		"id" : {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"current_puzzle" : {"data_type": "int", "primary_key": false, "not_null": true, "auto_increment": false},
		"died" : {"data_type": "int", "primary_key": false, "not_null": true, "auto_increment": false},
		"last_pos_y" : {"data_type": "int", "primary_key": false, "not_null": true, "auto_increment": false},
		"last_pos_x" : {"data_type": "int", "primary_key": false, "not_null": true, "auto_increment": false},
		"completed_init" : {"data_type": "int", "primary_key": false, "not_null": true, "auto_increment": false},
	}
	
	db.create_table("player_data", playerTable)
	
	db.insert_row("player_data", {"current_puzzle": 0, "died": 0, "last_pos_y": 708, "last_pos_x": 249, "completed_init": 0})
