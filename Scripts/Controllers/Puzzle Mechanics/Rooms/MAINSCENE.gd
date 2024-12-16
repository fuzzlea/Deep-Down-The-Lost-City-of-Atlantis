extends Node2D

func _ready():
	CAMERA.zoomTo($Player.position, Vector2(5,5))
