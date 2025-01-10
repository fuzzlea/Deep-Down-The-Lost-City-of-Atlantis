extends Node2D

@onready var plr = $Player
@onready var kelp = $Kelp
@onready var crate = $Crate
@onready var button = $Button
@onready var relic = $Collectable
@onready var telepad = $Telepad

var Dialogues = {
	0: [
		"A relic is a 'superpower' you can use to help you complete puzzles.",
		"There are 5 relics in the game ...",
		"... you can discover new relics throughout the game."
	],
	1: [
		"Hayden I'm going to need a chest / searchable from you for this relic to be inside. :pray_emoji:"
	],
	2: [
		"The only way to get by the kelp and complete the tutorial ..."
	],
	3: [
		"... is by pushing that button."
	],
	4: [
		"But you are too weak to push the button yourself.",
		"Try using your new relic to push the crate into the button."
	]
}

func buttonPressed():
	plr.emit_signal("disableMovement")
	
	CAMERA.zoomTo(Vector2(72,-6), Vector2(5,5))
	
	await get_tree().create_timer(2).timeout
	await CAMERA.resetCameraBackToPlayer()

func _ready():
	
	plr.emit_signal("disableMovement")
	SOUNDS.playMusic("underwater ambience")
	
	CAMERA.zoomTo(plr.position, Vector2(5,5))
	var d1 = DIALOGUE.newDialogue(Dialogues[0])
	
	await d1.Completed
	
	CAMERA.zoomTo(relic.position, Vector2(7,7))
	var d2 = DIALOGUE.newDialogue(Dialogues[1])
	
	await d2.Completed
	
	CAMERA.zoomTo(kelp.position, Vector2(7,7))
	var d3 = DIALOGUE.newDialogue(Dialogues[2])
	
	await d3.Completed
	
	CAMERA.zoomTo(button.position, Vector2(7,7))
	var d4 = DIALOGUE.newDialogue(Dialogues[3])
	
	await d4.Completed
	
	CAMERA.zoomTo(plr.position, Vector2(5,5))
	var d5 = DIALOGUE.newDialogue(Dialogues[4])
	
	await d5.Completed
	await CAMERA.resetCameraBackToPlayer()
	
	button.Recieve.connect(buttonPressed)
	
	telepad.Ran.connect(func():
		if not DATA.Data["TutorialsCompleted"].has("RelicTutorial"): DATA.Data["TutorialsCompleted"].append("RelicTutorial")
	)
