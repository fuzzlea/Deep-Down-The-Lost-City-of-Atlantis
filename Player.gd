extends CharacterBody2D

# Exports #

@export var State : String = "Idle"
@export var Direction : String = "Down"
@export var RelicSelected : String = "Push"

# Const #

const ACCEL : float = 10.0 # Player Acceleration Value
var SPEED : float = 80.0 # Set as var so i can manipulate

# Onready #

@onready var AnimatedSprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var Camera : Camera2D = $Camera2D

@onready var UI : CanvasLayer = $UI
@onready var RelicWheelUI : TextureRect = $UI/RelicWheel
@onready var RelicWheelHBOX : HBoxContainer = $UI/RelicWheel/HBoxContainer

@onready var Templates : Node2D = $Templates
@onready var RelicWheelTemplate = $Templates/RelicWheelButton

# Vars #

## MOVEMENT ##

var moveInput : Vector2 # The Player Movement Input Vector
var prevState : String # The players previous state
var prevDir : String # The players previous direction
var currentMovementControls : bool = true

## RELICS ##

var currentRelicDB : bool = false

## PUSHING ##

var timeBetweenPush : float = 0.5
var pushForce : float = -115
var areasInPushRange : Array = []

var pushDirectionHashmap : Dictionary = {
	"Up": Vector2(0,-1),
	"Down": Vector2(0,1),
	"Left": Vector2(-1,0),
	"Right": Vector2(1,0),
	"UpLeft": Vector2(-0.5,-0.5),
	"UpRight": Vector2(0.5,-0.5),
	"DownLeft": Vector2(-0.5,0.5),
	"DownRight": Vector2(0.5,0.5)
}

## RELIC WHEEL ##

var relicWheelOpen : bool :
	set(value):
		if value == true:
			
			var relicWheelTween = get_tree().create_tween().set_trans(Tween.TRANS_CIRC)
			relicWheelTween.tween_property(RelicWheelUI, "position", Vector2(272,615), 0.2)
			
			disablePlayerControls()
			CAMERA.zoomTo(global_position, Vector2(4,4), {"Time": 0.4, "Transition": Tween.TRANS_SINE})
			
		elif value == false:
			
			var relicWheelTween = get_tree().create_tween().set_trans(Tween.TRANS_CIRC)
			relicWheelTween.tween_property(RelicWheelUI, "position", Vector2(272,815), 0.2)
			
			var camTween = await(CAMERA.resetCameraBackToPlayer())
			
			await camTween
			
			enablePlayerControls()

var relicWheelSelected : int = 0

var relicsForWheel = {
	"Pressure Gloves" = {"Img": "res://Assets/Singles (Misc)/Puzzle Mechanics/Recievers/Button.png"},
	"Aqua Lobber" = {"Img": "res://Assets/Singles (Misc)/Puzzle Mechanics/Recievers/Button.png"},
	"Hydro Battery" = {"Img": "res://Assets/Singles (Misc)/Collectibles/Relics/Hydro Battery.png"},
	"Golden Magnet" = {"Img": "res://Assets/Singles (Misc)/Puzzle Mechanics/Recievers/Button.png"},
	"Poseidons Trident" = {"Img": "res://Assets/Singles (Misc)/Puzzle Mechanics/Recievers/Button.png"},
}

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
		
	if currentRelicDB == true:
		State = RelicSelected
	
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

## COLLECTABLES ##

func pickUpCollectable(collectable : Sprite2D):
	var itemName = collectable.get_meta("CollectableName")
	INVENTORY.addToInventory(itemName, 1)
	
	var itemTween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_parallel(true)
	itemTween.tween_property(collectable, "scale", Vector2(0,0), 0.5)
	itemTween.tween_property(collectable.get_child(0), "modulate", Color(0,0,0,0), 0.5)
	itemTween.tween_callback(func(): collectable.queue_free)

## RELICS ##

func useRelicAbility():
	if RelicSelected == "Push":
		currentRelicDB = true
		velocity = getMovementInput() * pushForce # Move the player back for a little bounce
		
		var itemToPush : RigidBody2D = areasInPushRange[0].get_parent() # Get the item to push
		var dirToPush : Vector2 = pushDirectionHashmap[Direction] * abs(pushForce) # Get the direction to push that item
		
		itemToPush.apply_central_impulse(dirToPush) # Apply a force to the item, emulating a push
		itemToPush.set_meta("Pushed", true) # Set the metadata of the pushed item
		
		await get_tree().create_timer(timeBetweenPush).timeout # Wait timeBetweenPush
		
		currentRelicDB = false
		itemToPush.set_meta("Pushed", false)

func initRelicWheel():
	for relic in relicsForWheel:
		var newTemplate : MarginContainer = RelicWheelTemplate.duplicate()
		newTemplate.visible = true
		newTemplate.get_child(0).get_child(0).texture = load(relicsForWheel[relic]["Img"])
		newTemplate.get_child(0).texture_normal = load("res://Assets/Singles (Misc)/Collectibles/Relics/Relic Border.png")
		RelicWheelHBOX.add_child(newTemplate)

# Connectors #

func _ready():
	CAMERA.CurrentCamera = Camera
	CAMERA.Player = self
	
	relicWheelOpen = false
	initRelicWheel()

func _physics_process(delta): # This function runs on every physics frame of the game
	
	## MOVEMENT ##
	if currentMovementControls:
		var movementInput = getMovementInput()
		
		velocity = lerp(velocity, movementInput * SPEED, delta * ACCEL) # Smoothly update the velocity of the player
		move_and_slide() # A godot built in function for CharacterBody2D nodes to allow for phsyics based positioning
	
	## PUSHING ##
	if Input.is_action_just_pressed("Player-Push"): # Check if the player pushes the key for the mechanic of whatever relic they have selected
		if currentRelicDB == false: # Make sure the player is able to use their relic
			if areasInPushRange.size() <= 0: return # Make sure something is in range
			
			useRelicAbility() # Use the ability of the relic selected
	
	## Relic Wheel ##
	if Input.is_action_just_pressed("Player-RelicWheel"):
		relicWheelOpen = true
	if Input.is_action_just_released("Player-RelicWheel"):
		relicWheelOpen = false
	
	## GLOBAL ##
	setState()
	setDirection()

func _on_push_range_area_entered(area: Area2D): # This function adds everything that is pushable to an array
	if area.get_meta("Pushable"):
		areasInPushRange.insert(0, area)

func _on_push_range_area_exited(area: Area2D): # This function removes the item from the array
	if area.get_meta("Pushable"):
		areasInPushRange.erase(area)

func _on_collectable_range_area_entered(area: Area2D) -> void:
	if area.get_parent().get_meta("Collectable"):
		pickUpCollectable(area.get_parent())
