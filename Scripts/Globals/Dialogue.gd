extends Node

@onready var DialogueScene = preload("res://Scenes/UI/Dialogue.tscn")

func newDialogue(dialogue : Array = ["There is no dialogue to display"]):
	var newD = DialogueScene.instantiate()
	newD.Dialogue = dialogue
	newD.Index = 0
	get_tree().get_root().add_child.call_deferred(newD)
	return newD
