extends CanvasLayer

@export var Dialogue = []
@export var Index = 0
@export var Busy = false

func typeWrite(text : String, speed = 0.04):
	$BG/Dialogue.text = ""
	Busy = true
	for c in text:
		$BG/Dialogue.text += c
		await get_tree().create_timer(speed).timeout
		
	Busy = false

func killDialogue(): 
	var t = $BG.create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	t.tween_property($BG, "position", Vector2(183, 1100), 0.5)
	
	await t.finished
	
	Index = 0
	Dialogue = []
	queue_free()

func nextButtonClicked():
	if Busy: return
	if Dialogue.size() - 1 == Index:
		killDialogue()
		return
	
	Index += 1
	
	typeWrite(Dialogue[Index])

func animateIn():
	var t = $BG.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	
	t.tween_property($BG, "position", Vector2(183, 821), 0.5)
	
	return t

func _ready():
	
	$BG.position = Vector2(183, 1100)
	$BG/Dialogue.text = ""
	
	await animateIn().finished
	
	if Dialogue.size() < 1:
		Dialogue = ["There was no dialogue input"]
	
	typeWrite(Dialogue[Index])

func _on_next_pressed() -> void:
	nextButtonClicked()
