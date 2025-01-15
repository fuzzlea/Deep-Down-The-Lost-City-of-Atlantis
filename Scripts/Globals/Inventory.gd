extends Node

# EXPORTS

@export var RarityColors : Dictionary = {
	
	"Common": Color(0.867, 0.863, 0.91),
	"Uncommon": Color(0.584, 0.922, 0.627),
	"Rare": Color(0.592, 0.886, 1),
	"Epic": Color(0.843, 0.592, 1),
	"Legendary": Color(1, 0.867, 0.42),
	
}

@export var ItemInformation : Dictionary = {
	# Common #
	
	"Anchor Pendent": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Anchor Pendent.png",
		"Rarity": "Common"
	},
	
	"Atlantean Bath Token": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Atlantean Bath Token.png",
		"Rarity": "Common"
	},
	
	"Atlantean Chess Piece": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Atlantean Chess Piece.png",
		"Rarity": "Common"
	},
	
	"Atlantean Clay Idol": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Atlantean Clay Idol.png",
		"Rarity": "Common"
	},
	
	"Atlantean Feather Quill": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Atlantean Feather Quill.png",
		"Rarity": "Common"
	},
	
	"Atlantean Pottery Shard": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Atlantean Pottery Shard.png",
		"Rarity": "Common"
	},
	
	"Fish-Scale Hairpin": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Fish-Scale Hairpin.png",
		"Rarity": "Common"
	},
	
	"Glass Coral Bead Necklace": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Glass Coral Bead Necklace.png",
		"Rarity": "Common"
	},
	
	"Puzzle Piece": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Puzzle Piece.png",
		"Rarity": "Common"
	},
	
	"Sand Dollar": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Sand Dollar.png",
		"Rarity": "Common"
	},
	
	"Seaweed-Wrapped Scroll": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Seaweed-Wrapped Scroll.png",
		"Rarity": "Common"
	},
	
	"Spoon": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Spoon.png",
		"Rarity": "Common"
	},
	
	"Starfish Clay Plate": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Starfish Clay Plate.png",
		"Rarity": "Common"
	},
	
	"Tadpole Statue": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Common/Tadpole Statue.png",
		"Rarity": "Common"
	},
	
	# Uncommon #
	
	"Checkers Piece": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Uncommon/Checkers Piece.png",
		"Rarity": "Uncommon"
	},
	
	"Conch Shell": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Uncommon/Conch Shell.png",
		"Rarity": "Uncommon"
	},
	
	"Fork": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Uncommon/Fork.png",
		"Rarity": "Uncommon"
	},
	
	"Gull Statue": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Uncommon/Gull Statue.png",
		"Rarity": "Uncommon"
	},
	
	"Knights Helm": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Uncommon/Knights Helm.png",
		"Rarity": "Uncommon"
	},
	
	"Pearl Beads": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Uncommon/Peral Beads.png",
		"Rarity": "Uncommon"
	},
	
	# Rare #
	
	"Golden Mask": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Rare/Golden Mask.png",
		"Rarity": "Rare"
	},
	
	"Sunfish Statue": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Rare/Sunfish Satue.png",
		"Rarity": "Rare"
	},
	
	"Tidal Mosaic Tile": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Rare/Tidal Mosaic Tile.png",
		"Rarity": "Rare"
	},
	
	# Epic #
	
	"Ceremonial Sea Shell": { #DONE
		"Image": "res://Assets/Singles (Misc)/Collectibles/Epic/Ceremonial Sea Shell.png",
		"Rarity": "Epic"
	},
	
	"Glass Sea Star": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Epic/Glass Sea Star.png",
		"Rarity": "Epic"
	},
	
	"Megaladon Tooth": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Epic/Megaladon Tooth.png",
		"Rarity": "Epic"
	},
	
	"Obsidian Necklace": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Epic/Obsidian Necklace.png",
		"Rarity": "Epic"
	},
	
	# Legendary #
	
	"Coral Crown Fragment": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Legendary/Coral Crown Fragment.png",
		"Rarity": "Legendary"
	},
	
	"Golden Spork": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Legendary/Golden Spork.png",
		"Rarity": "Legendary"
	},
	
	"Poseidons Crown": {
		"Image": "res://Assets/Singles (Misc)/Collectibles/Legendary/Poseidons Crown.png",
		"Rarity": "Legendary"
	},
	
}

@export var relicInformation : Dictionary = {
	
	"Pressure Gloves": "res://Assets/Singles (Misc)/Collectibles/Relics/Pressure Gloves.png",
	"Aqua Lobber": "res://Assets/Singles (Misc)/Collectibles/Relics/Aqua Lobber.png",
	"Golden Magnet": "res://Assets/Singles (Misc)/Collectibles/Relics/Golden Magnet.png",
	"Hydro Battery": "res://Assets/Singles (Misc)/Collectibles/Relics/Hydro Battery.png",
	"Poseidons Trident": "res://Assets/Singles (Misc)/Collectibles/Relics/Poseidons Trident.png",
	
}

# ONREADY

@onready var popUpScene : PackedScene = preload("res://Scenes/UI/UnlockPopup.tscn")

# VAR

var Inventory = []
var Stats = {
	
}

# FUNC

# This function plays the animation that displays a new item, whenever a new item is unlocked
func playFindAnimation(what : String, isRelic : bool):
	
	var newPopup = popUpScene.instantiate()
	newPopup.item = what
	
	if not isRelic:
		newPopup.isRelic = false
	else:
		newPopup.isRelic = true
	
	get_tree().current_scene.add_child(newPopup)

# This function adds an item to the inventory
func addToInventory(what : String , amount : int, silent : bool = false):
	if findInInventory(what):
		var item = findInInventory(what)
		item[1] += amount
	else:
		if not silent:
			playFindAnimation(what, false)
		var newInventoryLine = [what, amount]
		Inventory.insert(0, newInventoryLine)

# This function removes an item from the inventory
func removeItemInInventory(what : String , amount : int):
	if findInInventory(what):
		var item = findInInventory(what)
		item[1] -= amount
	else:
		return null

# This function finds an item in the inventory
func findInInventory(what : String):
	for item in Inventory:
		if item[0] == what:
			return item

# This function unlocks a relic
func unlockRelic(what : String):
	if DATA.Data["Relics"][what][0] == true: return
	if relicInformation[what]:
		playFindAnimation(what, true)
		DATA.Data["Relics"][what][0] = true
		#print(DATA.Data["Relics"][what][1])
	else:
		print("Relic " + what + " not found")

# This function returns the inventory
func returnInventory(): return Inventory
