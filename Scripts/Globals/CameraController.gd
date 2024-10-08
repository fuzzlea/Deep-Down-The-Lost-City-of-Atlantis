extends Node

@onready var CurrentCamera : Camera2D
@onready var Player : CharacterBody2D

func setCamera(camera : Camera2D):
	CurrentCamera = camera
	CurrentCamera.make_current()

func moveCameraTo(where : Vector2, waitTime : int = 0, tweenInfo : Dictionary = {
	"Time": 1,
	"Transition": Tween.TRANS_SINE
}):
	
	CurrentCamera.reparent(get_tree().current_scene)
	
	var newCamTween = get_tree().create_tween().set_trans(tweenInfo.Transition)
	newCamTween.tween_property(CurrentCamera, "position",where,tweenInfo.Time)
	
	await get_tree().create_timer(waitTime).timeout
	
	newCamTween.tween_property(CurrentCamera, "position", Vector2(0,0), tweenInfo.Time)
	newCamTween.play()
	
	await newCamTween.finished
	
	CurrentCamera.position = Vector2(0,0)
	CurrentCamera.reparent(Player)
	
	return newCamTween

func zoomTo(where : Vector2 = Vector2(0,0) , howFar : Vector2 = Vector2(3,3), tweenInfo : Dictionary = {
	"Time": 1,
	"Transition": Tween.TRANS_SINE
}, reset : bool = false):
	
	CurrentCamera.reparent(get_tree().current_scene)
	
	var cameraTween = get_tree().create_tween().set_trans(tweenInfo.Transition).set_parallel(true)
	cameraTween.tween_property(CurrentCamera, "global_position", where, tweenInfo.Time)
	cameraTween.tween_property(CurrentCamera, "zoom", howFar,  tweenInfo.Time)
	
	return cameraTween

func resetCameraBackToPlayer():
	
	var cameraTween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_parallel(true)
	cameraTween.tween_property(CurrentCamera, "zoom", Vector2(3,3), 0.25)
	cameraTween.tween_property(CurrentCamera, "position", Vector2(0,0), 0.5)
	cameraTween.tween_property(CurrentCamera, "global_position", Player.global_position, 0.5)
	
	await cameraTween.finished
	
	CurrentCamera.reparent(Player)
	
	return cameraTween
