extends RigidBody2D

@onready var AnimSpr : AnimatedSprite2D = $AnimatedSprite2D

signal popBubble

func killBubble():
	AnimSpr.play("Pop")
	name = "deadAquaLobber"
	
	await AnimSpr.animation_finished
	
	queue_free()

func _ready() -> void:
	AnimSpr.play("Float")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	killBubble()

func _on_pop_bubble() -> void:
	killBubble()
