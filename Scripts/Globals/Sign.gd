extends Node

# ONREADY

@onready var SignScene = preload("res://Scenes/UI/Sign.tscn")

# VAR

var currentSignsUp = {}

# FUNC

# This function will tween in the sign
func tweenIn(SignInstance : CanvasLayer):
	SignInstance.get_child(0).scale = Vector2(0,0)
	
	var newTween = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	newTween.tween_property(SignInstance.get_child(0), "scale", Vector2(1,1), 0.2)

# This function will tween out the sign
func tweenOut(SignInstance : CanvasLayer):
	var newTween = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	newTween.tween_property(SignInstance.get_child(0), "scale", Vector2(0,0), 0.2)

# This function will make a new sign, and display the given text [text]
func DisplayNew(text : String):
	
	if currentSignsUp.has(text) : return
	
	var newScene : CanvasLayer = SignScene.instantiate()
	currentSignsUp[text] = newScene
	
	var signDisplay : TextureRect = newScene.get_child(0)
	var signText : Label = signDisplay.get_child(0)
	var signButton : Button = signDisplay.get_child(1)
	
	signButton.pressed.connect(func():
		Remove(text)
	)
	
	signText.text = text
	
	tweenIn(newScene)
	
	get_tree().current_scene.add_child(newScene)

# This function will remove the sign
func Remove(text : String):
	if currentSignsUp.has(text): tweenOut(currentSignsUp[text]); currentSignsUp.erase(text)
