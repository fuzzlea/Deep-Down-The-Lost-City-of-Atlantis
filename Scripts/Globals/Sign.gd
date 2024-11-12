extends Node

@onready var SignScene = preload("res://Scenes/UI/Sign.tscn")

var currentSignsUp = {}

func tweenIn(SignInstance : CanvasLayer):
	SignInstance.get_child(0).scale = Vector2(0,0)
	
	var newTween = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	newTween.tween_property(SignInstance.get_child(0), "scale", Vector2(1,1), 0.2)

func tweenOut(SignInstance : CanvasLayer):
	var newTween = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	newTween.tween_property(SignInstance.get_child(0), "scale", Vector2(0,0), 0.2)

func DisplayNew(text : String):
	
	if currentSignsUp.has(text) : return
	
	var newScene : CanvasLayer = SignScene.instantiate()
	currentSignsUp[text] = newScene
	
	tweenIn(newScene)
	
	get_tree().current_scene.add_child(newScene)

func Remove(text : String):
	if currentSignsUp.has(text): tweenOut(currentSignsUp[text]); currentSignsUp.erase(text)
