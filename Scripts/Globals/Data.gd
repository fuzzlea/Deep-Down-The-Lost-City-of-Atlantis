extends Node

@export var Data : Dictionary = {
	"Relics": {
		
		"Pressure Gloves": [false, "res://Assets/Singles (Misc)/Collectibles/Relics/Pressure Gloves.png"],
		"Aqua Lobber": [true, "res://Assets/Singles (Misc)/Collectibles/Relics/Aqua Lobber.png"],
		"Golden Magnet": [false, "res://Assets/Singles (Misc)/Collectibles/Relics/Golden Magnet.png"],
		"Hydro Battery": [false, "res://Assets/Singles (Misc)/Collectibles/Relics/Hydro Battery.png"],
		"Poseidons Trident": [false, "res://Assets/Singles (Misc)/Collectibles/Relics/Poseidons Trident.png"],
		
	},
	#"Item": {},
	#"Relics": {},
	#"Relics": {},
}

@onready var loadingScreen = preload("res://Scenes/UI/LoadingScreen.tscn")

func loadSceneWithScreen(scenePath : String):
	var newLoadingScreen = loadingScreen.instantiate()
	newLoadingScreen.nextScenePath = scenePath
	
	get_tree().get_root().add_child(newLoadingScreen)
