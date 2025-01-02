extends CanvasLayer

@export var Dialogue = []
@export var Index = 0
@export var Busy = false

signal Completed
signal NextButton

func typeWrite(text : String, speed = 0.02):
	$BG/Dialogue.text = ""
	Busy = true
	for c in text:
		$BG/Dialogue.text += c
		await get_tree().create_timer(speed).timeout
		
	Busy = false

func killDialogue(): 
	var t = $BG.create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	t.tween_property($BG, "position", Vector2(160, 1000), 0.5)
	
	await t.finished
	
	Index = 0
	Dialogue = []
	Completed.emit()
	queue_free()

func nextButtonClicked():
	if Busy: return
	if Dialogue.size() - 1 == Index:
		killDialogue()
		return
	
	Index += 1
	NextButton.emit()
	
	typeWrite(Dialogue[Index])

func resetButtonScale():
	var tween = self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($BG/Next, "scale", Vector2(1,1),.2)

func scaleButtonDown():
	var tween = self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($BG/Next, "scale", Vector2(.95,.95),.2)

func scaleButtonUp():
	var tween = self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($BG/Next, "scale", Vector2(1.2,1.2),.2)

func animateIn():
	var t = $BG.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	
	t.tween_property($BG, "position", Vector2(160, 680), 0.5)
	
	return t

func _ready():
	
	$BG.position = Vector2(160, 1000)
	$BG/Dialogue.text = ""
	
	await animateIn().finished
	
	if Dialogue.size() < 1:
		Dialogue = ["There was no dialogue input"]
	
	typeWrite(Dialogue[Index])

func _on_next_pressed() -> void:
	
	nextButtonClicked()
	
	if Input.is_key_pressed(KEY_SHIFT):
		killDialogue()
