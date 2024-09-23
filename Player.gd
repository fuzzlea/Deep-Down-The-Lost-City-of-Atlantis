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
func animatePlayer(): # This function animates the player
	var animString = State + Direction # Composes a string of the state and the direction to play the correct animation
	AnimatedSprite.play(animString) # Plays the animation

func setDirection(): # This function sets the export var 'Direction' depending on the players movement
	var movementInput : Vector2 = getMovementInput()
	if movementInput.x > 0:
		if movementInput.y < 0:
			Direction = "UpRight"
			return
		elif movementInput.y > 0:
			Direction = "DownRight"
			return
		else:
			Direction = "Right"
			return
	if movementInput.x < 0:
		if movementInput.y < 0:
			Direction = "UpLeft"
			return
		elif movementInput.y > 0:
			Direction = "DownLeft"
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

func setState(): # This function sets the export var 'State' of the player
	var movementInput : Vector2 = getMovementInput()
	if movementInput != Vector2.ZERO: # If the player is moving
		State = "Walk"
	else:
		State = "Idle"
	if prevState != State || prevDir != Direction: # Check when the state or direction changes, animate & update those previous variables
		animatePlayer()
		prevState = State
		prevDir = Direction

func getMovementInput(): # This function gets the movement vector of the player depending on what keys they press
	moveInput.x = Input.get_action_strength("Player-MoveRight") - Input.get_action_strength("Player-MoveLeft")
	moveInput.y = Input.get_action_strength("Player-MoveDown") - Input.get_action_strength("Player-MoveUp")
	return moveInput.normalized() # This will return the Vector clamped from -1 to 1 which gives access to using speed variables

func disablePlayerControls(): # This will disable the player controls so they cannot move
	currentMovementControls = false
	State = "Idle"
	animatePlayer()

func enablePlayerControls(): # This will enable the player controls so they can move
	currentMovementControls = true

# Connectors #

func _physics_process(delta): # This function runs on every physics frame of the game
	
	## MOVEMENT ##
	if currentMovementControls:
		var movementInput = getMovementInput()
		
		velocity = lerp(velocity, movementInput * SPEED, delta * ACCEL) # Smoothly update the velocity of the player
		setState()
		setDirection()
		move_and_slide() # A godot built in function for CharacterBody2D nodes to allow for phsyics based positioning
