extends Node

@export var COMPLETED_INIT_PROCESS = true

@export var Data : Dictionary = {
	"Relics": {
		
		"Pressure Gloves": [true, "res://Assets/Singles (Misc)/Collectibles/Relics/Pressure Gloves.png"],
		"Aqua Lobber": [true, "res://Assets/Singles (Misc)/Collectibles/Relics/Aqua Lobber.png"],
		"Golden Magnet": [true, "res://Assets/Singles (Misc)/Collectibles/Relics/Golden Magnet.png"],
		"Hydro Battery": [true, "res://Assets/Singles (Misc)/Collectibles/Relics/Hydro Battery.png"],
		"Poseidons Trident": [true, "res://Assets/Singles (Misc)/Collectibles/Relics/Poseidons Trident.png"],
		
	},
	"TutorialsCompleted": [
		
	],
	#"Relics": {},
	#"Relics": {},
}

@onready var loadingScreen = preload("res://Scenes/UI/LoadingScreen.tscn")

func loadSceneWithScreen(scenePath : String):
	var newLoadingScreen = loadingScreen.instantiate()
	newLoadingScreen.nextScenePath = scenePath
	
	get_tree().get_root().add_child(newLoadingScreen)
