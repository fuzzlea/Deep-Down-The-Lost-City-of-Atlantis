extends CharacterBody2D

# Exports #

@export var State : String = "Idle"
@export var Direction : String = "Down"

# Const #

const ACCEL : float = 10.0 # Player Acceleration Value
const SPEED : float = 250.0

# Onready #

@onready var AnimatedSprite : AnimatedSprite2D = $AnimatedSprite2D

# Vars #

## MOVEMENT ##
var moveInput : Vector2 # The Player Movement Input Vector
var prevState : String # The players previous state
var prevDir : String # The players previous direction
var currentMovementControls : bool = true

# Func #

## MOVEMENT / ANIMATION ##
func animatePlayer():
	var animString = State + Direction
	AnimatedSprite.play(animString)

func setDirection():
	var movementInput : Vector2 = getMovementInput()
	if movementInput.x > 0:
		if movementInput.y < 0:
			#Direction = "UpRight"
			return
		elif movementInput.y > 0:
			#Direction = "DownRight"
			return
		else:
			Direction = "Right"
			return
	if movementInput.x < 0:
		if movementInput.y < 0:
			#Direction = "UpLeft"
			return
		elif movementInput.y > 0:
			#Direction = "DownLeft"
			return
		else:
			Direction = "Left"
			return
	if movementInput.x == 0 && movementInput.y > 0:
		Direction = "Down"
		return
	elif movementInput.x == 0 && movementInput.y < 0:
		Direction = "Up"
		return

func setState():
	var movementInput : Vector2 = getMovementInput()
	if movementInput != Vector2.ZERO:
		State = "Walk"
	else:
		State = "Idle"
	if prevState != State || prevDir != Direction:
		animatePlayer()
		prevState = State
		prevDir = Direction

func getMovementInput():
	moveInput.x = Input.get_action_strength("Player-MoveRight") - Input.get_action_strength("Player-MoveLeft")
	moveInput.y = Input.get_action_strength("Player-MoveDown") - Input.get_action_strength("Player-MoveUp")
	return moveInput.normalized()

func disablePlayerControls():
	currentMovementControls = false
	State = "Idle"
	animatePlayer()

func enablePlayerControls():
	currentMovementControls = true

# Connectors #

func _process(delta):
	
	## MOVEMENT ##
	if currentMovementControls:
		var movementInput = getMovementInput()
		
		velocity = lerp(velocity, movementInput * SPEED, delta * ACCEL)
		setState()
		setDirection()
		move_and_slide()
