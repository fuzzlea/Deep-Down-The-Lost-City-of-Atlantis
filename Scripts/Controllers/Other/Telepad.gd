extends Area2D

# SIGNAL

@warning_ignore("unused_signal")
signal Interact(scenePath)
signal Ran

# EXPORT

@export var pathToScene : String

# This setget function runs and updates the texture depending on if its locked or not
@export var Locked : bool :
	set(v):
		Locked = v
		
		if !v:
			$Sprite2D.texture = load("res://Assets/Singles (Misc)/Puzzle Mechanics/Senders/Telepad ON.png")
			$CPUParticles2D.visible = true

# FUNC

# This function runs when the telepad runs, and emits the signal 'ran'
func Telepad(player):
	
	var _t = CAMERA.zoomTo(self.position, Vector2(10,10))
	
	SOUNDS.playSound("tp")
	
	if get_tree().current_scene.name == "Main":
		DATA.Data["LastPosInMain"] = player.position
	
	DATA.loadSceneWithScreen(pathToScene)
	Ran.emit()

# CONNECTORS

# This function sets the texture when the scene is ready
func _ready():
	if Locked: $Sprite2D.texture = load("res://Assets/Singles (Misc)/Puzzle Mechanics/Senders/Telepad OFF.png"); $CPUParticles2D.visible = false

# This function connects the interact signal to the telepad function
func _on_interact(player) -> void:
	Telepad(player)
