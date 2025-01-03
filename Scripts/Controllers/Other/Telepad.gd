extends Area2D

@warning_ignore("unused_signal")
signal Interact(scenePath)
signal Ran

@export var pathToScene : String
@export var Locked : bool :
	set(v):
		Locked = v
		
		if !v:
			$Sprite2D.texture = load("res://Assets/Singles (Misc)/Puzzle Mechanics/Senders/Telepad ON.png")
			$CPUParticles2D.visible = true

func Telepad():
	
	var _t = CAMERA.zoomTo(self.position, Vector2(10,10))
	
	DATA.loadSceneWithScreen(pathToScene)
	Ran.emit()

func _ready():
	if Locked: $Sprite2D.texture = load("res://Assets/Singles (Misc)/Puzzle Mechanics/Senders/Telepad OFF.png"); $CPUParticles2D.visible = false

func _on_interact() -> void:
	Telepad()
