extends Node

@onready var CurrentCamera : Camera2D
@onready var Player : CharacterBody2D

func setCamera(camera : Camera2D):
	CurrentCamera = camera
	CurrentCamera.make_current()

func moveCameraTo(where : Vector2, tweenInfo : Dictionary = {
	"Time": 1,
	"Transition": Tween.TRANS_SINE
}):
	
	CurrentCamera.reparent(get_tree().current_scene)
	
	var newCamTween = get_tree().create_tween().set_trans(tweenInfo.Transition)
	newCamTween.tween_property(CurrentCamera, "position",where,tweenInfo.Time)
	newCamTween.play()
	
	await newCamTween.finished
	
	CurrentCamera.reparent(Player)
	
	var camBackTween = get_tree().create_tween().set_trans(tweenInfo.Transition)
	camBackTween.tween_property(CurrentCamera, "position", Vector2(0,0), tweenInfo.Time)
	camBackTween.play()
	
	await camBackTween.finished
	
	CurrentCamera.position = Vector2(0,0)
	
	return camBackTween
