extends Sprite2D

# Export #

@export var Type : String = "Gun"

# Vars #

# Func #

func setRotation():
	var mouseVector : Vector2 = get_local_mouse_position()
	
	if mouseVector.x < 0 :
		# facing left
		flip_h = true
	else:
		#facing right
		flip_h = false

# Connectors #

func _process(_delta):
	setRotation()
