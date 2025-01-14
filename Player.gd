extends CharacterBody2D

# SIGNALS

@warning_ignore("unused_signal")
signal disableMovement
@warning_ignore("unused_signal")
signal enableMovement
@warning_ignore("unused_signal")
signal unpauseGame

# EXPORTS

@export var State : String = "Idle"
@export var Direction : String = "Down"
@export var RelicSelected : String = "Push"

# CONST

const ACCEL : float = 10.0 # Player Acceleration Value
var SPEED : float = 80.0 # Set as var so i can manipulate

# ONREADY

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

# VAR

var moveInput : Vector2 
var prevState : String 
var prevDir : String 
var currentMovementControls : bool = true
var gamePaused : bool = false
var lastFootStepInt = 0

var itemsInInteractRange : Array = []

var currentRelicDB : bool = false
var aquaLobberScene = preload("res://Scenes/Singles (Misc)/AquaLobber.tscn")

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

# This setget function will update the relic wheels position
var relicWheelOpen : bool :
	set(value):
		#if CAMERA.Busy: return
		relicWheelOpen = value
		
		initRelicWheel()
		animatePlayer()
		
		if value == true:
			
			var relicWheelTween = get_tree().create_tween().set_trans(Tween.TRANS_CIRC)
			relicWheelTween.tween_property(RelicWheelUI, "position", Vector2(592,975), 0.2)
			
			disablePlayerControls()
			
		elif value == false:
			
			var relicWheelTween = get_tree().create_tween().set_trans(Tween.TRANS_CIRC)
			relicWheelTween.tween_property(RelicWheelUI, "position", Vector2(592,1200), 0.2)
			
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

# FUNC

# This function animates the player according to the state and the direction
func animatePlayer():
	var animString = State + Direction
	AnimatedSprite.play(animString)

# This function sets the direction given the players movement input
func setDirection():
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

# This function sets the state of the player according to the movement vector
func setState():
	if currentMovementControls == false: return
	
	var movementInput : Vector2 = getMovementInput()
	
	if movementInput != Vector2.ZERO:
		State = "Walk"
	else:
		State = "Idle"
		
	if currentRelicDB == true:
		State = RelicSelected
	
	if prevState != State || prevDir != Direction:
		animatePlayer()
		prevState = State
		prevDir = Direction

# This function returns the normalized vector of the players movement || Vector2(0.3123,0.21851) -> Vector2(0.5,0.5) 
func getMovementInput():
	moveInput.x = Input.get_action_strength("Player-MoveRight") - Input.get_action_strength("Player-MoveLeft")
	moveInput.y = Input.get_action_strength("Player-MoveDown") - Input.get_action_strength("Player-MoveUp")
	return moveInput.normalized() # This will return the Vector clamped from -1 to 1 which gives access to using speed variables

# Disable the players ability to move
func disablePlayerControls():
	currentMovementControls = false
	State = "Idle"
	animatePlayer()

# Enable the players ability to move
func enablePlayerControls():
	currentMovementControls = true

# This function will pick up a collectable, and depending on the type of collectable, call to the inventory accordingly
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
	else: return

# This function will run whenever the player tries to use their relic, and perform a different action according to the selected relic
func useRelicAbility():
	if relicWheelOpen == true: return
	
	var unlockedRelic : bool = DATA.Data["Relics"][relicSetsToRelicNames[RelicSelected]][0]
	if not unlockedRelic: return
	
	match RelicSelected:
		"Push":
			if areasInPushRange.size() <= 0: return
			
			currentRelicDB = true
			
			velocity = getMovementInput() * pushForce
			
			var itemToPush : RigidBody2D = areasInPushRange[0].get_parent()
			var dirToPush : Vector2 = pushDirectionHashmap[Direction] * abs(pushForce)
			
			itemToPush.apply_central_impulse(dirToPush)
			itemToPush.set_meta("Pushed", true)
			
			SOUNDS.playSound("ui_swoop")
			
			await get_tree().create_timer(timeBetweenPush).timeout
			
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

# This function will initialize the relic wheel to off screen
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

# This function will run whenever the relic wheel scroll keybind is pressed (in this case, mouse wheel scroll up / down) 
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

# This function will show the interaction icon
func showInteractIcon():
	
	InteractionIcon.visible = true
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(InteractionIcon, "scale", Vector2(1,1), 0.2)

# This function will hide the interaction icon
func hideInteractIcon():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(InteractionIcon, "scale", Vector2(0,0), 0.1)
	
	tween.tween_callback(func(): InteractionIcon.visible = false)

# This function will pause the game
func pauseController():
	if gamePaused: return
	if CAMERA.Busy: return
	
	gamePaused = true
	
	var newPause = PauseScene.instantiate()
	UI.add_child(newPause)
	
	newPause.emit_signal("AnimateIn")

# CONNECTORS

# This function essentially works as an initializer, setting all of the variables and updating certain game rules
func _ready():
	CAMERA.CurrentCamera = Camera
	CAMERA.Player = self
	
	InteractionIcon.visible = false
	InteractionIcon.scale = Vector2(0,0)
	
	relicWheelOpen = false
	
	get_tree().auto_accept_quit = false
	
	initRelicWheel()
	relicWheelScroll("None")

# This function runs every frame, checking for differnet keybind inputs, and running certain functions accordingly
func _physics_process(delta):
	
	if currentMovementControls:
		var movementInput = getMovementInput()
		
		velocity = lerp(velocity, movementInput * SPEED, delta * ACCEL)
		move_and_slide() 
	
	if Input.is_action_just_pressed("Player-Push"):
		if currentRelicDB == false:
			useRelicAbility()
	
	if Input.is_action_just_pressed("Player-Interaction"):
		if itemsInInteractRange.size() > 0:
			SOUNDS.playSound("ui_pop")
			if itemsInInteractRange[0].has_meta("Telepad"):
				itemsInInteractRange[0].emit_signal("Interact", self); return
				
			itemsInInteractRange[0].emit_signal("Interact")
	
	if Input.is_action_just_pressed("Player-RelicWheel"):
		SOUNDS.playSound("ui_swoop")
		relicWheelOpen = true
	if Input.is_action_just_released("Player-RelicWheel"):
		relicWheelOpen = false
	
	if Input.is_action_just_pressed("Player-Pause"):
		pauseController()
	if Input.is_action_just_pressed("Player-SaveData"):
		DATA.SAVE_DATA.emit()
	if Input.is_action_just_pressed("Player-RelicWheelScrollUp"):
		if relicWheelOpen == false: return
		SOUNDS.playSound("ui_tick01")
		relicWheelScroll("Down")
	
	if Input.is_action_just_pressed("Player-RelicWheelScrollDown"):
		if relicWheelOpen == false: return
		SOUNDS.playSound("ui_tick01")
		relicWheelScroll("Up")
	
	setState()
	setDirection()

# This function will add an item to the pushable items IF in range, and able to be pushed
func _on_push_range_area_entered(area: Area2D):
	if area.get_meta("Pushable"):
		areasInPushRange.insert(0, area)

# This function will remove the item from the above function
func _on_push_range_area_exited(area: Area2D):
	if area.get_meta("Pushable"):
		areasInPushRange.erase(area)

# This function runs when anything collectable has entered the range of the player
func _on_collectable_range_area_entered(area: Area2D) -> void:
	if area.has_meta("Interactable"): return
	if area.has_meta("Pushable"): return
	if CAMERA.Busy: return
	if area.get_parent().get_meta("Collectable"):
		pickUpCollectable(area.get_parent())

# This function runs on the 'enableMovement' signal
func _on_enable_movement() -> void:
	enablePlayerControls()

# This function runs on the 'disableMovement' signal
func _on_disable_movement() -> void:
	disablePlayerControls()

# This function runs when something enters the interaction range, and handles all of that logic accordingly
func _on_interaction_range_area_entered(area : Area2D):
	if area.has_meta("Interactable"):
		
		if area.has_meta("Telepad"):
			if area.Locked: return
		
		showInteractIcon()
		SOUNDS.playSound("ui_droop")
		itemsInInteractRange.append(area)

# This does the same as above, except when something exits the interaction range
func _on_interaction_range_area_exited(area: Area2D) -> void:
	if itemsInInteractRange.has(area):
		itemsInInteractRange.erase(area)
		if itemsInInteractRange.size() == 0: hideInteractIcon()

# This function runs when the application recieves a notification from the OS, for example, to close the window 
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		
		if get_tree().current_scene.name == "Main":
			DATA.Data["LastPosInMain"] = position
		
		DATA.emit_signal("SAVE_DATA")
		
		await get_tree().create_timer(0.5).timeout
		
		get_tree().quit()

# This function unpauses the game
func _on_unpause_game() -> void:
	gamePaused = false

# This function runs when the footstep timer ticks
func _on_footstep_timer_timeout() -> void:
	if State == "Walk":
		var randint = randi_range(1,11)
		SOUNDS.playSound("foot" + str(randint))
