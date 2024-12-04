extends Area2D

@warning_ignore("unused_signal")
signal Interact(scenePath)

@export var pathToScene : String

func Telepad():
	DATA.loadSceneWithScreen(pathToScene)

func _on_interact() -> void:
	Telepad()
