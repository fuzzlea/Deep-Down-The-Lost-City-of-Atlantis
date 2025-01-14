extends Sprite2D

# SIGNAL

signal Recieve
signal Send

# EXPORTS

@export var SendTo : Node

# REGULAR VAR

var pushedImage = load("res://Assets/Singles (Misc)/Puzzle Mechanics/Recievers/Button Pushed.png")

var pushables = [
	"Crate",
]

# FUNC

# Send a signal to the item in the place of the var [SendTo] 
func send():
	SendTo.emit_signal("Recieve")

# Runs when the button is pushed, changes the texture, plays a sound, then emits a signal to the [SendTo] var
func recieve():
	texture = pushedImage
	SOUNDS.playSound("button_click")
	
	if not SendTo: return
	
	emit_signal("Send")

# CONNECTORS

# Connects the signals for when they need to run
func _ready():
	Recieve.connect(recieve)
	Send.connect(send)

# Runs when something with the name of pushables[any] enters the range
func _on_hit_range_area_entered(area: Area2D) -> void:
	if pushables.has(area.get_parent().name):
		emit_signal("Recieve")
