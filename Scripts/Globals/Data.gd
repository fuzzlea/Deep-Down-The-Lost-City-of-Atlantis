extends Node

@export var COMPLETED_INIT_PROCESS = false

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
	"CurrentPuzzle": 0
	
}

func loadSceneWithScreen(scenePath : String):
	
	var loadingScreen = preload("res://Scenes/UI/LoadingScreen.tscn")
	
	var newLoadingScreen = loadingScreen.instantiate()
	newLoadingScreen.nextScenePath = scenePath
	
	if newLoadingScreen: get_tree().get_root().add_child(newLoadingScreen)
