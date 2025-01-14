extends Node2D

# ONREADY

@onready var World = $TileMap
@onready var Player = $Player
@onready var Kelp = $KelpLine
@onready var Crab = $Crab

# VAR

var LoadingScreen

# This setget function will run when the variable value changes, and when it does, an animation will play
var crabReachedKelp : bool = false:
	set(val):
		if val == true:
			
			var zoomTween = CAMERA.zoomTo(Vector2(365,330), Vector2(4,4), {"Time": 1.2, "Transition": Tween.TRANS_SINE})
			
			await zoomTween.finished
			
			await get_tree().create_timer(1).timeout
			
			CAMERA.resetCameraBackToPlayer()

# CONNECTORS

# When the map loads, teh player and crab are unable to move, and a cinematic plays. When finished, the player and crab are able to move again
func _ready():
	
	Player.emit_signal("disableMovement")
	Crab.emit_signal("disableMovement")
	SOUNDS.playMusic("underwater ambience")
	
	var firstTween = CAMERA.zoomTo(Vector2(177,255), Vector2(5,5), {"Time": 1.5, "Transition": Tween.TRANS_SINE})
	
	DIALOGUE.newDialogue([
		"Crabs are going to be crucial during your exploration.",
		"They can cut through any leafy / weak object."
		])
	
	await firstTween.finished
	await get_tree().create_timer(0.5).timeout
	
	var secondTween = CAMERA.zoomTo(Vector2(378,302), Vector2(4,4), {"Time": 1.5, "Transition": Tween.TRANS_SINE})
	
	await secondTween.finished
	await get_tree().create_timer(0.5).timeout
	
	CAMERA.resetCameraBackToPlayer()
	
	Crab.emit_signal("enableMovement")
	Player.emit_signal("enableMovement")
	
	await $Telepad.Ran
	
	if not DATA.Data["TutorialsCompleted"].has("CrabsAndKelp"): DATA.Data["TutorialsCompleted"].append("CrabsAndKelp")
	

# This function runs every frame, checking if the crabs position is beyond the kelp, and if it is, it updates the [crabReachedKelp] var
func _process(_delta: float) -> void:
	if Crab.global_position.x >= 378:
		set_process(false)
		crabReachedKelp = true
		return
