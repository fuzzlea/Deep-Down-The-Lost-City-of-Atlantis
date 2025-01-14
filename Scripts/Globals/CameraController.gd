extends Node

# ONREADY

@onready var CurrentCamera : Camera2D
@onready var Player : CharacterBody2D

# EXPORT

@export var Busy : bool = false

# FUNC

# Sets the camera to the player camera, making it easier to select and manipulate
func setCamera(camera : Camera2D):
	CurrentCamera = camera
	CurrentCamera.make_current()

# This function moves the camera to [where], in [waitTime] seconds
func moveCameraTo(where : Vector2, waitTime : int = 0, tweenInfo : Dictionary = {
	"Time": 1,
	"Transition": Tween.TRANS_SINE
}):
	
	Busy = true
	
	Player.emit_signal("disableMovement")
	
	CurrentCamera.reparent(get_tree().current_scene)
	
	var newCamTween = get_tree().create_tween().set_trans(tweenInfo.Transition)
	newCamTween.tween_property(CurrentCamera, "position",where,tweenInfo.Time)
	
	await get_tree().create_timer(waitTime).timeout
	
	newCamTween.tween_property(CurrentCamera, "position", Vector2(0,0), tweenInfo.Time)
	newCamTween.play()
	
	await newCamTween.finished
	
	CurrentCamera.position = Vector2(0,0)
	CurrentCamera.reparent(Player)
	
	Player.emit_signal("enableMovement")
	
	Busy = false
	return newCamTween

# This function does the same as the above function, but will also zoom in the camera [howFar] much
func zoomTo(where : Vector2 = Vector2(0,0) , howFar : Vector2 = Vector2(3,3), tweenInfo : Dictionary = {
	"Time": 1,
	"Transition": Tween.TRANS_SINE
}, _reset : bool = false):
	
	Busy = true
	
	CurrentCamera.reparent(get_tree().current_scene)
	
	Player.emit_signal("disableMovement")
	
	var cameraTween = get_tree().create_tween().set_trans(tweenInfo.Transition).set_parallel(true)
	cameraTween.tween_property(CurrentCamera, "global_position", where, tweenInfo.Time)
	cameraTween.tween_property(CurrentCamera, "zoom", howFar,  tweenInfo.Time)
	
	return cameraTween

# This function resets the camera back to the players position
func resetCameraBackToPlayer():
	
	Busy = true
	
	Player.emit_signal("disableMovement")
	
	var cameraTween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_parallel(true)
	cameraTween.tween_property(CurrentCamera, "zoom", Vector2(3.5,3.5), 0.5)
	cameraTween.tween_property(CurrentCamera, "position", Vector2(0,0), 0.5)
	cameraTween.tween_property(CurrentCamera, "global_position", Player.global_position, 0.5)
	
	await cameraTween.finished
	
	CurrentCamera.reparent(Player)
	Player.emit_signal("enableMovement")
	
	Busy = false
	return cameraTween
