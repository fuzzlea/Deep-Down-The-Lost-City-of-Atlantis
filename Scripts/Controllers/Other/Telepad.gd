extends Area2D

@warning_ignore("unused_signal")
signal Interact(scenePath)
signal Ran

@export var pathToScene : String

func Telepad():
	DATA.loadSceneWithScreen(pathToScene)
	Ran.emit()

func _on_interact() -> void:
	Telepad()
