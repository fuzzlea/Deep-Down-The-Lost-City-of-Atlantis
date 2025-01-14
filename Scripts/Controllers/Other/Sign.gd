extends Area2D

# EXPORT

@export var DisplayText : String = "This sign has no information"

# SIGNALS

@warning_ignore("unused_signal")
signal Interact

# CONNECTOR

# This function will display a new sign from the controller when the interact signal is emitted
func _on_interact() -> void:
	SIGN.DisplayNew(DisplayText)
