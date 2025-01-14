extends Control

# ONREADY

@onready var Logo : TextureRect = $Logo
@onready var AnimPlayer : AnimationPlayer = $AnimationPlayer
@onready var AnimSpriteBG : AnimatedSprite2D = $AnimatedSprite2D
@onready var PlayButton : TextureButton = $PlayButton

# FUNC

# This function initializes the main menu elements to their correct positions
func resetAllElementsToInit():
	Logo.position = Vector2(479.5, -400)
	PlayButton.position = Vector2(696, 1200)

# This function will animate in the element 'elementName'
func animateInElement(elementName : String):
	match elementName:
		"Logo":
			var logo_tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			logo_tween.tween_property(Logo, "position", Vector2(479.5,0),2)
			logo_tween.tween_callback(func(): animateLoopedElement("Logo"))
		"PlayButton":
			var pb_tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			pb_tween.tween_property(PlayButton, "position", Vector2(696,579), 2)
			pb_tween.tween_callback(func(): animateLoopedElement("PlayButton"))

# This function will animate a looped version of the above function
func animateLoopedElement(elementName : String):
	match elementName:
		"Logo":
			AnimPlayer.play("LogoBobLoop")
		"BG":
			AnimSpriteBG.play("default")
		"PlayButton":
			AnimPlayer.play("PlayButtonLoop")

# CONNECTORS

# This function tweens the size of the play button when the mouse enters
func _on_play_button_mouse_entered() -> void:
	SOUNDS.playSound("ui_tick01")
	var tweenUp = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tweenUp.tween_property(PlayButton, "scale", Vector2(1.15,1.15),0.15)

# This function tweens the size of the play button when the mouse exits
func _on_play_button_mouse_exited() -> void:
	var tweenDown = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tweenDown.tween_property(PlayButton, "scale", Vector2(1,1),0.15)

# This function tweens the size of the button when the mouse clicks
func _on_play_button_button_down() -> void:
	var tweenDown = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tweenDown.tween_property(PlayButton, "scale", Vector2(0.85,0.85),0.15)

# This function tweens the size of the button when the mouse if lifted
func _on_play_button_button_up() -> void:
	var tweenUp = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tweenUp.tween_property(PlayButton, "scale", Vector2(1,1),0.15)

# This function starts the game when the play button is clicked
func _on_play_button_pressed() -> void:
	
	DATA.emit_signal("LOAD_DATA")
	
	SOUNDS.playSound("ui_click01")
	
	if DATA.HAS_DATA:
		DATA.loadSceneWithScreen("res://Scenes/MAIN.tscn")
	else:
		DATA.loadSceneWithScreen("res://Scenes/Tutorials/BasicMovementTut.tscn")

# This function runs when the game is very first opened / initialized & ready
func _ready():
	resetAllElementsToInit()
	
	animateInElement("Logo")
	animateLoopedElement("BG")
	
	SOUNDS.playMusic("menu music")
	
	await get_tree().create_timer(1).timeout
	
	animateInElement("PlayButton")

# This function will crash the game, used for testing & crash detection
func _on_button_pressed() -> void:
	while true:
		pass
