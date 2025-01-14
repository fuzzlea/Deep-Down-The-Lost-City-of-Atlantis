extends RigidBody2D

# ONREADY

@onready var AnimSpr : AnimatedSprite2D = $AnimatedSprite2D

# SIGNALS

@warning_ignore("unused_signal")
signal popBubble

# FUNC

# Pops the bubble
func killBubble():
	AnimSpr.play("Pop")
	name = "deadAquaLobber"
	
	await AnimSpr.animation_finished
	
	queue_free()

# CONNECTORS

# Plays the float animation
func _ready() -> void:
	AnimSpr.play("Float")

# Pops the bubble when hitting the screen limits
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	killBubble()

# On the pop signal, the bubble actually pops
func _on_pop_bubble() -> void:
	killBubble()
