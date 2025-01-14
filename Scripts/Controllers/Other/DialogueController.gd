extends CanvasLayer

# EXPORTS

@export var Dialogue = []
@export var Index = 0
@export var Busy = false

# SIGNALS

signal Completed
signal NextButton

# FUNC

# This function creates a typewriter effect for the dialogue displayed
func typeWrite(text : String, speed = 0.02):
	$BG/Dialogue.text = ""
	Busy = true
	for c in text:
		$BG/Dialogue.text += c
		SOUNDS.playSound("ui_lettertick",true)
		await get_tree().create_timer(speed).timeout
		
	Busy = false

# This function will get rid of the dialogue box
func killDialogue(): 
	var t = $BG.create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	t.tween_property($BG, "position", Vector2(160, 1000), 0.5)
	
	await t.finished
	
	Index = 0
	Dialogue = []
	Completed.emit()
	queue_free()

# This function updates the dialogue to be displayed when the button is clicked to progress
func nextButtonClicked():
	if Busy: return
	
	SOUNDS.playSound("ui_click01")
	
	if Dialogue.size() - 1 == Index:
		killDialogue()
		return
	
	Index += 1
	NextButton.emit()
	
	typeWrite(Dialogue[Index])

# This function returns the buttons scale back to normal
func resetButtonScale():
	var tween = self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($BG/Next, "scale", Vector2(1,1),.2)

# This function will scale the button down
func scaleButtonDown():
	var tween = self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($BG/Next, "scale", Vector2(.95,.95),.2)

# This function will scale the button up
func scaleButtonUp():
	SOUNDS.playSound("ui_tick01")
	var tween = self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($BG/Next, "scale", Vector2(1.2,1.2),.2)

# This function animates the dialogue box for when it comes in
func animateIn():
	var t = $BG.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	
	t.tween_property($BG, "position", Vector2(160, 680), 0.5)
	
	return t

# CONNECTORS

# Initializes the dialogue box, and sets the text to be displayed
func _ready():
	
	$BG.position = Vector2(160, 1000)
	$BG/Dialogue.text = ""
	
	await animateIn().finished
	
	if Dialogue.size() < 1:
		Dialogue = ["There was no dialogue input"]
	
	typeWrite(Dialogue[Index])

# Runs when the next button is clicked
func _on_next_pressed() -> void:
	
	nextButtonClicked()
	
	if Input.is_key_pressed(KEY_SHIFT):
		killDialogue()
