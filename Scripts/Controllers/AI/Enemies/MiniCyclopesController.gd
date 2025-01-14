extends RigidBody2D

# EXPORTS

@export var State : String
@export var States : Array
@export var AIUpdateTime : float = 0.5

# ONREADY

@onready var AI_Timer : Timer = $AI_Timer
@onready var AnimSprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var HitRange : Area2D = $HitRange

# VAR

var currentlyMoving : bool = false
var ableToMove : bool = true
var nextDirection = null

# FUNC

# This function returns a random state from [States]
func pickRandomState():
	return States[randi_range(0,States.size() - 1)]

# This function moves the cyclopes randomly (Very similar, if not the exact same as the crab)
func moveRandomly():
	
	if not ableToMove: return
	if currentlyMoving: return
	
	currentlyMoving = true
	var randDirection = ["Left", "Right"][randi_range(0,1)]
	
	if nextDirection: randDirection = nextDirection
	
	match randDirection:
		"Left":
			apply_central_impulse(Vector2(0,-100))
		"Right":
			apply_central_impulse(Vector2(0,100))
	
	currentlyMoving = false

# This function runs every time the AI Timer ticks
func update(): 
	
	if not ableToMove: return
	if currentlyMoving: return
	
	var newState = pickRandomState()
	State = newState
	
	AnimSprite.play(State)
	
	match newState:
		"Moving":
			moveRandomly()
		"Idle":
			pass
		_:
			pass

# CONNECTORS

# This function will start the update timer when the cyclopes scene is ready
func _ready():
	
	AI_Timer.wait_time = AIUpdateTime
	AI_Timer.start()

# This function checks every frame if the cyclopse was pushed, and update its ability to move accordingly
func _process(_delta : float):
	
	if get_meta("Pushed") == true:
		
		AnimSprite.play("Pushed")
		ableToMove = false
		
	else:
		
		ableToMove = true

# This function connects the timer to the update function
func _on_ai_timer_timeout():
	update()

# This function checks for the cyclopes hitting a wall, and moves it accordingly
func _on_hit_range_body_entered(body: Node2D):
	if body is TileMap:
		if body.global_position.x - global_position.x > 0:
			nextDirection = "Right"
		else:
			nextDirection = "Left"

# This function immediately sets next direction to nothing, fixing an error the above function was giving
func _on_hit_range_body_exited(body: Node2D):
	if body is TileMap:
		nextDirection = null
