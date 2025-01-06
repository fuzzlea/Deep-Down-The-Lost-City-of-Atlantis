extends Node

signal LOAD_DATA
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

func loadData():
	print('d')

func initDataTable():
	
	print("INIT DATA")
	
	var tutorialsTable = {
		"id" : {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"name" : {"data_type": "text", "primary_key": false, "not_null": true, "auto_increment": false},
		"completed" : {"data_type": "int", "primary_key": false, "not_null": true, "auto_increment": false},
	}
	
	db.create_table("tutorials", tutorialsTable)
	
	db.insert_row("tutorials", {"name": "MovementTutorial", "completed": 0})
	db.insert_row("tutorials", {"name": "CrabsAndKelpTutorial", "completed": 0})
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
		"asset_location" : {"data_type": "text", "primary_key": false, "not_null": true, "auto_increment": false},
	}
	
	db.create_table("relics", relicsTable)
	
	db.insert_row("relics", {"name": "Pressure Gloves", "asset_location": "res://Assets/Singles (Misc)/Collectibles/Relics/Pressure Gloves.png"})
	db.insert_row("relics", {"name": "Aqua Lobber", "asset_location": "res://Assets/Singles (Misc)/Collectibles/Relics/Aqua Lobber.png"})
	db.insert_row("relics", {"name": "Golden Magnet", "asset_location": "res://Assets/Singles (Misc)/Collectibles/Relics/Golden Magnet.png"})
	db.insert_row("relics", {"name": "Hydro Battery", "asset_location": "res://Assets/Singles (Misc)/Collectibles/Relics/Hydro Battery.png"})
	db.insert_row("relics", {"name": "Poseidons Trident", "asset_location": "res://Assets/Singles (Misc)/Collectibles/Relics/Poseidons Trident.png"})
	
	var playerTable = {
		"id" : {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"current_puzzle" : {"data_type": "int", "primary_key": false, "not_null": true, "auto_increment": false},
		"died" : {"data_type": "int", "primary_key": false, "not_null": true, "auto_increment": false},
		"last_pos_y" : {"data_type": "int", "primary_key": false, "not_null": true, "auto_increment": false},
		"last_pos_x" : {"data_type": "int", "primary_key": false, "not_null": true, "auto_increment": false},
	}
	
	db.create_table("player_data", playerTable)
	
	db.insert_row("player_data", {"current_puzzle": 0, "died": 0, "last_pos_y": 708, "last_pos_x": 249})
