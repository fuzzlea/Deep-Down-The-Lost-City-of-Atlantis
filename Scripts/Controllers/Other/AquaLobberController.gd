extends RigidBody2D

func _ready():
	print("Ready")

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
