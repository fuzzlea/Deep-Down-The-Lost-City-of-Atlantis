extends Node2D

@onready var plr = $Player

var Dialogues = {
	0: [
		"Welcome to Deep Down: The Lost City of Atlantis.",
		"Your goal is to complete intricate puzzles ...",
		"... and discover lost artifacts!",
		"Let's dive in, shall we?"
	],
	1: [
		"Over here you'll find different puzzle rooms for you to complete.",
		"Be sure to be on the lookout for artifacts to add to your collection!"
	],
	2: [
		"If you need a tutorial on how to play the game, come over here.",
		"This will teach you all you need to know about the base mechanics of the game."
	],
	3: [
		"Good luck diver!"
	]
}

func _ready():
	if DATA.COMPLETED_INIT_PROCESS == false:
		plr.emit_signal("disableMovement")
		CAMERA.zoomTo($Player.position, Vector2(5,5))
		
		var dialogue1 = DIALOGUE.newDialogue(Dialogues[0])
		await dialogue1.Completed
		
		var camTween1 = CAMERA.zoomTo($CamPos/CamPos1.position, Vector2(4,4))
		await camTween1.finished
		
		var dialogue2 = DIALOGUE.newDialogue(Dialogues[1])
		await dialogue2.Completed
		
		var camTween2 = CAMERA.zoomTo($CamPos/CamPos2.position, Vector2(4,4))
		await camTween2.finished
		
		var dialogue3 = DIALOGUE.newDialogue(Dialogues[2])
		await dialogue3.Completed
		
		CAMERA.resetCameraBackToPlayer()
		
		var dialogue4 = DIALOGUE.newDialogue(Dialogues[3])
		await dialogue4.Completed
		
		plr.emit_signal("enableMovement")
		DATA.COMPLETED_INIT_PROCESS = true
