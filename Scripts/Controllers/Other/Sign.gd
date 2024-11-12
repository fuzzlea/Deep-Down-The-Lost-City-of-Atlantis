extends Area2D

@export var DisplayText : String = "This sign has no information"

@warning_ignore("unused_signal")
signal Interact

func _on_interact() -> void:
	SIGN.DisplayNew(DisplayText)
