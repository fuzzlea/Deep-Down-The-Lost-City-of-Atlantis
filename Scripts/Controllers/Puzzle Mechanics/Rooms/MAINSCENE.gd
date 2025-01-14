extends Node2D

# ONREADY

@onready var plr = $Player

# VAR

var Dialogues = {
	0: [
		"Welcome to Deep Down: The Lost City of Atlantis.",
		"Your goal is to complete intricate puzzles, and complete your collection of lost artifacts!",
		"Let's dive in, shall we?"
	],
	1: [
		"Over here you'll find different puzzles for you to complete.",
	],
	"1a": [
		"There are different sections of puzzles, each requiring a different relic to complete.",
		"You can unlock relics by completing puzzles."
	],
	2: [
		"If you need a tutorial on how to play the game, come over here.",
		"This will teach you all you need to know about the base mechanics of the game."
	],
	3: [
		"You can view your collection at any time by going to the pause menu.",
		"Good luck diver!"
	]
}

# FUNC

# This function checks the players data, manipulating the main map accordingly
func checkData():
	
	for telepad in $PuzzleArea/Telepads.get_children():
		if DATA.Data["CurrentPuzzle"] >= int(str(telepad.name)):
			telepad.Locked = false
			if DATA.Data["CurrentPuzzle"] != int(str(telepad.name)):
				telepad.get_child(1).texture = load("res://Assets/Singles (Misc)/Puzzle Mechanics/Senders/TelepadCompleted.png")
				telepad.get_child(2).color = Color.from_string("#25885a", Color())
	
	if DATA.Data["TutorialsCompleted"].has("BasicMovement"):
		$TutorialArea/Telepad.get_child(1).texture = load("res://Assets/Singles (Misc)/Puzzle Mechanics/Senders/TelepadCompleted.png")
		$TutorialArea/Telepad.get_child(2).color = Color.from_string("#25885a", Color())
	if DATA.Data["TutorialsCompleted"].has("CrabsAndKelp"):
		$TutorialArea/Telepad2.get_child(1).texture = load("res://Assets/Singles (Misc)/Puzzle Mechanics/Senders/TelepadCompleted.png")
		$TutorialArea/Telepad2.get_child(2).color = Color.from_string("#25885a", Color())
	if DATA.Data["TutorialsCompleted"].has("RelicTutorial"):
		$TutorialArea/Telepad3.get_child(1).texture = load("res://Assets/Singles (Misc)/Puzzle Mechanics/Senders/TelepadCompleted.png")
		$TutorialArea/Telepad3.get_child(2).color = Color.from_string("#25885a", Color())

# CONNECTOR

# This function will set the players position to the last saved position, and give a short tutorial if the player doesn't have any data
func _ready():
	
	plr.position = DATA["Data"]["LastPosInMain"]
	SOUNDS.playMusic("underwater ambience")
	
	
	if DATA.COMPLETED_INIT_PROCESS == false:
		plr.emit_signal("disableMovement")
		CAMERA.zoomTo($Player.position, Vector2(5,5))
		
		var dialogue1 = DIALOGUE.newDialogue(Dialogues[0])
		await dialogue1.Completed
		
		var camTween1 = CAMERA.zoomTo($CamPos/CamPos1.position, Vector2(4,4))
		await camTween1.finished
		
		var dialogue2 = DIALOGUE.newDialogue(Dialogues[1])
		await dialogue2.Completed
		
		var camTween1a = CAMERA.zoomTo($CamPos/CamPos3.position, Vector2(4,4))
		await camTween1a.finished
		
		var dialogue2a = DIALOGUE.newDialogue(Dialogues["1a"])
		await dialogue2a.Completed
		
		var camTween2 = CAMERA.zoomTo($CamPos/CamPos2.position, Vector2(4,4))
		await camTween2.finished
		
		var dialogue3 = DIALOGUE.newDialogue(Dialogues[2])
		await dialogue3.Completed
		
		CAMERA.resetCameraBackToPlayer()
		
		var dialogue4 = DIALOGUE.newDialogue(Dialogues[3])
		await dialogue4.Completed
		
		plr.emit_signal("enableMovement")
		DATA.COMPLETED_INIT_PROCESS = true
	
	CAMERA.resetCameraBackToPlayer()
	checkData()
