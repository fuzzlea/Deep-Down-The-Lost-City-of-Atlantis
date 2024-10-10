extends RigidBody2D

# Signal #

@warning_ignore("unused_signal")
signal disableMovement
@warning_ignore("unused_signal")
signal enableMovement

# Exports #

@export var State : String
@export var States : Array
@export var AIUpdateTime : float = 1.0
@export var ForceDirection : String = "null"

# Onready #

@onready var AI_Timer : Timer = $AI_Timer
@onready var AnimSprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var HitRange : Area2D = $HitRange

# Var #

var currentlyMoving : bool = false
var ableToMove : bool = true
var nextDirection = null
var currentlyDisabled : bool = false

# Func #

func pickRandomState():
	return States[randi_range(0,States.size() - 1)]

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

func update(): # This function will run every set amount of seconds (AIUpdateTime), and will be the AI Controller
	
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

# Connectors #

func _ready(): # This function runs when the scene is instantiated
	
	if ForceDirection != "null":
		nextDirection = ForceDirection
	
	AI_Timer.wait_time = AIUpdateTime
	AI_Timer.start()

func _process(_delta : float):
	
	if currentlyDisabled: return
	
	if get_meta("Pushed") == true:
		
		AnimSprite.play("Pushed")
		ableToMove = false
		
	else:
		
		ableToMove = true
	
	if ForceDirection != "null":
		nextDirection = ForceDirection

func _on_ai_timer_timeout(): # This function runs every time the timer 'AI_Timer' finishes
	update()

func _on_hit_range_body_entered(body: Node2D): # This function runs whenever something enters the HitRange
	if body is TileMap:
		if body.global_position.x - global_position.x > 0:
			nextDirection = "Right" # Opposite of the position of the wall (Left)
		else:
			nextDirection = "Left" # Opposite of the position of the wall (Right)

func _on_hit_range_body_exited(body: Node2D): # This function runs whenever something leaves the HitRange
	if body is TileMap:
		nextDirection = null

func _on_enable_movement() -> void:
	ableToMove = true
	currentlyDisabled = false

func _on_disable_movement() -> void:
	ableToMove = false
	currentlyDisabled = true
