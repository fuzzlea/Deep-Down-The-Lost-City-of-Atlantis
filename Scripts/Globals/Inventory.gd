extends Node

@export var ItemInformation : Dictionary = {
	# Common #
	
	"Anchor Pendent": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Anchor Pendent.png"
	},
	
	"Atlantean Bath Token": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Atlantean Bath Token.png"
	},
	
	"Atlantean Chess Piece": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Atlantean Chess Piece.png"
	},
	
	"Atlantean Clay Idol": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Atlantean Clay Idol.png"
	},
	
	"Atlantean Feather Quill": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Atlantean Feather Quill.png"
	},
	
	"Atlantean Pottery Shard": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Atlantean Pottery Shard.png"
	},
	
	"Fish-Scale Hairpin": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Fish-Scale Hairpin.png"
	},
	
	"Glass Coral Bead Necklace": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Glass Coral Bead Necklace.png"
	},
	
	"Puzzle Piece": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Puzzle Piece.png"
	},
	
	"Sand Dollar": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Sand Dollar.png"
	},
	
	"Seaweed-Wrapped Scroll": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Seaweed-Wrapped Scroll.png"
	},
	
	"Spoon": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Spoon.png"
	},
	
	"Starfish Clay Plate": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Starfish Clay Plate.png"
	},
	
	"Tadpole Statue": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Tadpole Statue.png"
	}
	
	# Uncommon #
	
	# Rare #
	
	# Epic #
	
	# Legendary #
}

@export var relicInformation : Dictionary = {
	
	"Pressure Gloves": "res://Assets/Singles (Misc)/Collectibles/Relics/Pressure Gloves.png",
	"Aqua Lobber": "res://Assets/Singles (Misc)/Collectibles/Relics/Aqua Lobber.png",
	"Golden Magnet": "res://Assets/Singles (Misc)/Collectibles/Relics/Golden Magnet.png",
	"Hydro Battery": "res://Assets/Singles (Misc)/Collectibles/Relics/Hydro Battery.png",
	"Poseidons Trident": "res://Assets/Singles (Misc)/Collectibles/Relics/Poseidons Trident.png",
	
}

@onready var popUpScene : PackedScene = preload("res://Scenes/UI/UnlockPopup.tscn")

var Inventory = []
var Stats = {
	"Died": 0
}

func playFindAnimation(what : String, isRelic : bool):
	
	var newPopup = popUpScene.instantiate()
	newPopup.item = what
	
	if not isRelic:
		newPopup.isRelic = false
	else:
		newPopup.isRelic = true
	
	get_tree().current_scene.add_child(newPopup)

func addToInventory(what : String , amount : int):
	if findInInventory(what):
		var item = findInInventory(what)
		item[1] += amount
	else:
		playFindAnimation(what, false)
		var newInventoryLine = [what, amount]
		Inventory.insert(0, newInventoryLine)

func removeItemInInventory(what : String , amount : int):
	if findInInventory(what):
		var item = findInInventory(what)
		item[1] -= amount
	else:
		return null

func findInInventory(what : String):
	for item in Inventory:
		if item[0] == what:
			return item

func unlockRelic(what : String):
	if DATA.Data["Relics"][what][0] == true: return
	if relicInformation[what]:
		playFindAnimation(what, true)
		DATA.Data["Relics"][what][0] = true
		#print(DATA.Data["Relics"][what][1])
	else:
		print("Relic " + what + " not found")

func returnInventory(): return Inventory
