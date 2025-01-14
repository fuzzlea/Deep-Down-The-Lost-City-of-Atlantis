extends RigidBody2D

# SIGNAL

@warning_ignore("unused_signal")
signal disableMovement
@warning_ignore("unused_signal")
signal enableMovement

# EXPORT

@export var State : String
@export var States : Array
@export var AIUpdateTime : float = 1.0
@export var ForceDirection : String = "null"

# ONREADY

@onready var AI_Timer : Timer = $AI_Timer
@onready var AnimSprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var HitRange : Area2D = $HitRange

# VAR

var currentlyMoving : bool = false
var ableToMove : bool = true
var nextDirection = null
var currentlyDisabled : bool = false

# FUNC

# Returns a random state from the array of States - [States]
func pickRandomState():
	return States[randi_range(0,States.size() - 1)]

# Moves the crab in a random direction
func moveRandomly():
	
	if not ableToMove: return
	if currentlyMoving: return
	
	currentlyMoving = true
	var randDirection = ["Left", "Right"][randi_range(0,1)]
	
	if nextDirection: randDirection = nextDirection
	
	match randDirection:
		"Left":
			apply_central_impulse(Vector2(-100,0))
		"Right":
			apply_central_impulse(Vector2(100,0))
	
	currentlyMoving = false

# This function runs everytime the AI timer ticks [AIUpdateTime]
func update():
	
	if not ableToMove: return
	if currentlyMoving: return
	
	var newState = pickRandomState()
	State = newState
	
	if ForceDirection != "null": State = "Moving"
	
	AnimSprite.play(State)
	
	match State:
		"Moving":
			moveRandomly()
		"Idle":
			pass
		_:
			pass

# CONNECTOR

# Checks if theres a forced direction for the crab to go, and starts the update timer
func _ready():
	
	if ForceDirection != "null":
		nextDirection = ForceDirection
	
	AI_Timer.wait_time = AIUpdateTime
	AI_Timer.start()

# This function checks if the crab is pushed every frame, and updates its ability to move accordingly
func _process(_delta : float):
	
	if currentlyDisabled: return
	
	if get_meta("Pushed") == true:
		
		AnimSprite.play("Pushed")
		ableToMove = false
		
	else:
		
		ableToMove = true
	
	if ForceDirection != "null":
		nextDirection = ForceDirection

# Connects the timer to the update function
func _on_ai_timer_timeout():
	update()

# Checks when the crab hits a wall, and depending on what direction the crab hits the wall, it'll move in the opposite
func _on_hit_range_body_entered(body: Node2D):
	if body is TileMap:
		if body.global_position.x - global_position.x > 0:
			nextDirection = "Right"
		else:
			nextDirection = "Left"

# Checks when the crab hits a wall, and sets its movement to nothing, giving the function above room to be able to set the next direction and not have any issues
func _on_hit_range_body_exited(body: Node2D):
	if body is TileMap:
		nextDirection = null

# When the crab is able to move again, this function will run
func _on_enable_movement() -> void:
	ableToMove = true
	currentlyDisabled = false

# Same as the above function, but for disabling movement / when the crab can't move
func _on_disable_movement() -> void:
	ableToMove = false
	currentlyDisabled = true
