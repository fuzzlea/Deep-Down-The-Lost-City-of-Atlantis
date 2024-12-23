extends CharacterBody2D

# Signals #

@warning_ignore("unused_signal")
signal disableMovement
@warning_ignore("unused_signal")
signal enableMovement
@warning_ignore("unused_signal")
signal unpauseGame

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

@onready var OverPlayerUI : Control = $OverPlayerUI
@onready var InteractionIcon : TextureRect = $OverPlayerUI/InteractIcon

@onready var Templates : Node2D = $Templates
@onready var RelicWheelTemplate = $Templates/RelicWheelButton

@onready var PauseScene : PackedScene = preload('res://Scenes/UI/PauseMenu.tscn')

# Vars #

## MOVEMENT ##

var moveInput : Vector2 # The Player Movement Input Vector
var prevState : String # The players previous state
var prevDir : String # The players previous direction
var currentMovementControls : bool = true
var gamePaused : bool = false

## INTERACTIONS ##

var itemsInInteractRange : Array = []

## RELICS ##

var currentRelicDB : bool = false
var aquaLobberScene = preload("res://Scenes/Singles (Misc)/AquaLobber.tscn")

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
		#if CAMERA.Busy: return
		relicWheelOpen = value
		
		initRelicWheel()
		animatePlayer()
		
		if value == true:
			
			var relicWheelTween = get_tree().create_tween().set_trans(Tween.TRANS_CIRC)
			relicWheelTween.tween_property(RelicWheelUI, "position", Vector2(get_viewport().size.x / 2 - (RelicWheelUI.size.x / 2) , get_viewport().size.y - (RelicWheelUI.size.y + 40)), 0.2)
			
			disablePlayerControls()
			
		elif value == false:
			
			var relicWheelTween = get_tree().create_tween().set_trans(Tween.TRANS_CIRC)
			relicWheelTween.tween_property(RelicWheelUI, "position", Vector2(get_viewport().size.x / 2 - (RelicWheelUI.size.x / 2), get_viewport().size.y), 0.2)
			
			enablePlayerControls()

var relicWheelSelected : int = 0

var relicsForWheel = {
	"0" = {"Name": "Pressure Gloves", "Img": "res://Assets/Singles (Misc)/Collectibles/Relics/Pressure Gloves.png", "RelicSet": "Push"},
	"1" = {"Name": "Aqua Lobber", "Img": "res://Assets/Singles (Misc)/Collectibles/Relics/Aqua Lobber.png", "RelicSet": "Lobber"},
	"2" = {"Name": "Golden Magnet", "Img": "res://Assets/Singles (Misc)/Collectibles/Relics/Golden Magnet.png", "RelicSet": "Magnet"},
	"3" = {"Name": "Hydro Battery", "Img": "res://Assets/Singles (Misc)/Collectibles/Relics/Hydro Battery.png", "RelicSet": "Battery"},
	"4" = {"Name": "Poseidons Trident", "Img": "res://Assets/Singles (Misc)/Collectibles/Relics/Poseidons Trident.png", "RelicSet": "Trident"},
}

var relicSetsToRelicNames = {
	"Push": "Pressure Gloves",
	"Lobber": "Aqua Lobber",
	"Magnet": "Golden Magnet",
	"Battery": "Hydro Battery",
	"Trident": "Poseidons Trident"
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
	if currentMovementControls == false: return
	
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
	
	if collectable.get_meta("IsRelic") == true: 
		INVENTORY.unlockRelic(itemName)
	else:
		INVENTORY.addToInventory(itemName, 1)
	
	var itemTween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_parallel(true)
	itemTween.tween_property(collectable, "scale", Vector2(0,0), 0.5)
	itemTween.tween_property(collectable.get_child(0), "modulate", Color(0,0,0,0), 0.5)
	
	await itemTween.finished
	
	if collectable:
		collectable.queue_free()

## RELICS ##

func useRelicAbility():
	if relicWheelOpen == true: return
	
	var unlockedRelic : bool = DATA.Data["Relics"][relicSetsToRelicNames[RelicSelected]][0]
	if not unlockedRelic: return
	
	match RelicSelected:
		"Push":
			if areasInPushRange.size() <= 0: return # Make sure something is in range
			
			currentRelicDB = true
			
			velocity = getMovementInput() * pushForce # Move the player back for a little bounce
			
			var itemToPush : RigidBody2D = areasInPushRange[0].get_parent() # Get the item to push
			var dirToPush : Vector2 = pushDirectionHashmap[Direction] * abs(pushForce) # Get the direction to push that item
			
			itemToPush.apply_central_impulse(dirToPush) # Apply a force to the item, emulating a push
			itemToPush.set_meta("Pushed", true) # Set the metadata of the pushed item
			
			await get_tree().create_timer(timeBetweenPush).timeout # Wait timeBetweenPush
			
			currentRelicDB = false
			itemToPush.set_meta("Pushed", false)
		"Lobber":
			
			currentRelicDB = true
			
			if get_tree().current_scene.get_node_or_null("AquaLobber"):
				var bubble = get_tree().current_scene.get_node("AquaLobber")
				bubble.emit_signal("popBubble")
			else: pass
			
			var newLobber : RigidBody2D = aquaLobberScene.instantiate()
			get_tree().current_scene.add_child(newLobber)
			
			newLobber.name = "AquaLobber"
			newLobber.global_position = global_position
			
			var forceVector = pushDirectionHashmap[Direction]
			newLobber.apply_central_force(forceVector * 6)
			
			await get_tree().create_timer(1).timeout
			
			currentRelicDB = false
		"Magnet":
			pass

func initRelicWheel():
	
	for relic in RelicWheelHBOX.get_children():
		relic.queue_free()
	
	for relic in relicsForWheel:
		var unlockedRelic : bool = DATA.Data["Relics"][relicsForWheel[relic]["Name"]][0]
		var newTemplate : MarginContainer = RelicWheelTemplate.duplicate()
		
		newTemplate.visible = true
		newTemplate.name = relic
		
		if unlockedRelic:
			newTemplate.get_child(0).get_child(0).texture = load(relicsForWheel[relic]["Img"])
		else:
			newTemplate.get_child(0).get_child(0).texture = load("res://Assets/Singles (Misc)/Lock.png")
		
		newTemplate.get_child(0).texture_normal = load("res://Assets/Singles (Misc)/Collectibles/Relics/Relic Border.png")
		RelicWheelHBOX.add_child(newTemplate)
	
	relicWheelScroll("_")

func relicWheelScroll(updown : String):
	match updown:
		"Up":
			relicWheelSelected += 1
			relicWheelSelected = clamp(relicWheelSelected, 0, relicsForWheel.size() - 1)
		"Down":
			relicWheelSelected -= 1
			relicWheelSelected = clamp(relicWheelSelected, 0, relicsForWheel.size() - 1)
		_:
			pass
	
	RelicSelected = relicsForWheel[str(relicWheelSelected)]["RelicSet"]
	
	for relic : MarginContainer in RelicWheelHBOX.get_children():
		relic.create_tween().tween_property(relic, "scale", Vector2(1,1), 0.1).set_trans(Tween.TRANS_BACK)
		
		if relic.name == str(relicWheelSelected):
			relic.create_tween().tween_property(relic, "scale", Vector2(1.2,1.2), 0.1).set_trans(Tween.TRANS_BACK)

## INTERACTIONS ##

func showInteractIcon():
	
	InteractionIcon.visible = true
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(InteractionIcon, "scale", Vector2(1,1), 0.2)

func hideInteractIcon():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(InteractionIcon, "scale", Vector2(0,0), 0.1)
	
	tween.tween_callback(func(): InteractionIcon.visible = false)

func pauseController():
	if gamePaused: return
	if CAMERA.Busy: return
	
	gamePaused = true
	
	var newPause = PauseScene.instantiate()
	UI.add_child(newPause)
	
	newPause.emit_signal("AnimateIn")

# Connectors #

func _ready():
	CAMERA.CurrentCamera = Camera
	CAMERA.Player = self
	
	InteractionIcon.visible = false
	InteractionIcon.scale = Vector2(0,0)
	
	relicWheelOpen = false
	#RelicWheelUI.position = Vector2(get_viewport().size.x / 2 - (RelicWheelUI.size.x / 2), get_viewport().size.y)
	
	initRelicWheel()
	relicWheelScroll("None")

func _physics_process(delta): # This function runs on every physics frame of the game
	
	## MOVEMENT ##
	if currentMovementControls:
		var movementInput = getMovementInput()
		
		velocity = lerp(velocity, movementInput * SPEED, delta * ACCEL) # Smoothly update the velocity of the player
		move_and_slide() # A godot built in function for CharacterBody2D nodes to allow for phsyics based positioning
	
	## PUSHING ##
	if Input.is_action_just_pressed("Player-Push"): # Check if the player pushes the key for the mechanic of whatever relic they have selected
		if currentRelicDB == false: # Make sure the player is able to use their relic
			useRelicAbility() # Use the ability of the relic selected
	
	## INTERACTIONS ##
	if Input.is_action_just_pressed("Player-Interaction"):
		if itemsInInteractRange.size() > 0:
			itemsInInteractRange[0].emit_signal("Interact")
	
	## RELIC WHEEL ##
	if Input.is_action_just_pressed("Player-RelicWheel"):
		relicWheelOpen = true
	if Input.is_action_just_released("Player-RelicWheel"):
		relicWheelOpen = false
	
	if Input.is_action_just_pressed("Player-Pause"):
		pauseController()
	
	if Input.is_action_just_pressed("Player-RelicWheelScrollUp"):
		if relicWheelOpen == false: return
		relicWheelScroll("Down")
	
	if Input.is_action_just_pressed("Player-RelicWheelScrollDown"):
		if relicWheelOpen == false: return
		relicWheelScroll("Up")
	
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
	if area.has_meta("Interactable"): return
	if area.has_meta("Pushable"): return
	if area.get_parent().get_meta("Collectable"):
		pickUpCollectable(area.get_parent())

func _on_enable_movement() -> void:
	enablePlayerControls()

func _on_disable_movement() -> void:
	disablePlayerControls()

func _on_interaction_range_area_entered(area : Area2D):
	if area.has_meta("Interactable"):
		showInteractIcon()
		itemsInInteractRange.append(area)

func _on_interaction_range_area_exited(area: Area2D) -> void:
	if itemsInInteractRange.has(area):
		itemsInInteractRange.erase(area)
		if itemsInInteractRange.size() == 0: hideInteractIcon()

func _on_unpause_game() -> void:
	gamePaused = false
