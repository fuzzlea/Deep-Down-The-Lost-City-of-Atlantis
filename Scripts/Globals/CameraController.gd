extends Node

@onready var CurrentCamera : Camera2D

func setCamera(camera : Camera2D):
	CurrentCamera = camera
	CurrentCamera.make_current()

func moveCameraTo(where : Vector2, tweenInfo : Dictionary = {
	"TweenTime": 1,
	"Transition"
}):
	CurrentCamera.position
