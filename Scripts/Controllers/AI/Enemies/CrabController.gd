extends RigidBody2D

# Exports #

@export var State : String
@export var States : Array
@export var AIUpdateTime : int

# Onready #

@onready var AI_Timer : Timer = $AI_Timer
@onready var AnimSprite : AnimatedSprite2D = $AnimatedSprite2D

# Var #

var currentlyMoving : bool = false

# Func #

func pickRandomState():
	return States[randi_range(0,States.size() - 1)]

func moveRandomly():
	
	if currentlyMoving: return
	
	currentlyMoving = true
	var randDirection = ["Left", "Right"][randi_range(0,1)]
	
	match randDirection:
		"Left":
			apply_central_impulse(Vector2(-250,0))
		"Right":
			apply_central_impulse(Vector2(250,0))
	
	currentlyMoving = false

func update(): # This function will run every set amount of seconds (AIUpdateTime), and will be the AI Controller
	
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

# Connectors #

func _ready(): # This function runs when the scene is instantiated
	AI_Timer.wait_time = AIUpdateTime
	AI_Timer.start()

func _on_ai_timer_timeout(): # This function runs every time the timer 'AI_Timer' finishes
	update()
