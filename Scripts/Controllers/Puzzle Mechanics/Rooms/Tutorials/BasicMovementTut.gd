extends Node2D

# ONREADY

@onready var plr = $Player

# CONNECTORS

# When the map loads, the player is stopped from moving, and a cutscene plays
func _ready():
	plr.emit_signal("disableMovement")
	SOUNDS.playMusic("underwater ambience")
	
	var c1 = CAMERA.zoomTo(plr.position, Vector2(4, 4))
	await c1.finished
	
	var d1 = DIALOGUE.newDialogue([
		"Movement in this game is simple.",
		"W-A-S-D to move your diver.",
		"To open your relic wheel, either hold [TAB] or [RightMB]",
		"You'll learn more about relics in the third tutorial.",
		"Use your scroll wheel or your arrow keys to select a relic ...",
		"... you'll be able to use your selected relic (when unlocked) with [LeftMB] or [SPACE]",
		"Once you understand the controls, go to the telepad on the left to go back home."
		])
	
	await d1.Completed
	
	CAMERA.resetCameraBackToPlayer()
	plr.emit_signal("enableMovement")

# When the telepad is used, a value is added to the data set for the tutorials, so the game knows if the player has completed the tutorial.
func _on_telepad_ran() -> void:
	if not DATA.Data["TutorialsCompleted"].has("BasicMovement"): DATA.Data["TutorialsCompleted"].append("BasicMovement")
