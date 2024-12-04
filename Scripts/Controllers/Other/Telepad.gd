extends Area2D

signal Interact(scenePath)

@export var pathToScene : String

func Telepad():
	DATA.loadSceneWithScreen(pathToScene)

func _on_interact() -> void:
	Telepad()
