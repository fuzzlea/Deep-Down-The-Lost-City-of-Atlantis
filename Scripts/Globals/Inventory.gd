extends Node

var Inventory = []

func addToInventory(what : String , amount : int):
	if findInInventory(what):
		var item = findInInventory(what)
		item[1] += amount
	else:
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

func returnInventory(): return Inventory
