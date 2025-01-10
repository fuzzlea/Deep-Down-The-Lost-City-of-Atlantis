extends Sprite2D

signal Recieve
signal Send

@export var SendTo : Node

var pushedImage = load("res://Assets/Singles (Misc)/Puzzle Mechanics/Recievers/Button Pushed.png")

var pushables = [
	"Crate",
]

func send():
	SendTo.emit_signal("Recieve")

func recieve():
	texture = pushedImage
	SOUNDS.playSound("button_click")
	
	if not SendTo: return
	
	emit_signal("Send")

func _ready():
	Recieve.connect(recieve)
	Send.connect(send)

func _on_hit_range_area_entered(area: Area2D) -> void:
	if pushables.has(area.get_parent().name):
		emit_signal("Recieve")
