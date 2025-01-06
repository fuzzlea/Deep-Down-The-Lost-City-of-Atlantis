extends Control

@onready var Logo : TextureRect = $Logo
@onready var AnimPlayer : AnimationPlayer = $AnimationPlayer
@onready var AnimSpriteBG : AnimatedSprite2D = $AnimatedSprite2D
@onready var PlayButton : TextureButton = $PlayButton

func resetAllElementsToInit():
	Logo.position = Vector2(479.5, -400)
	PlayButton.position = Vector2(696, 1200)

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

func animateLoopedElement(elementName : String):
	match elementName:
		"Logo":
			AnimPlayer.play("LogoBobLoop")
		"BG":
			AnimSpriteBG.play("default")
		"PlayButton":
			AnimPlayer.play("PlayButtonLoop")

func _on_play_button_mouse_entered() -> void:
	var tweenUp = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tweenUp.tween_property(PlayButton, "scale", Vector2(1.15,1.15),0.15)

func _on_play_button_mouse_exited() -> void:
	var tweenDown = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tweenDown.tween_property(PlayButton, "scale", Vector2(1,1),0.15)

func _on_play_button_button_down() -> void:
	var tweenDown = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tweenDown.tween_property(PlayButton, "scale", Vector2(0.85,0.85),0.15)

func _on_play_button_button_up() -> void:
	var tweenUp = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tweenUp.tween_property(PlayButton, "scale", Vector2(1,1),0.15)

func _on_play_button_pressed() -> void:
	DATA.loadSceneWithScreen("res://Scenes/Tutorials/BasicMovementTut.tscn")
	DATA.emit_signal("LOAD_DATA")

func _ready():
	resetAllElementsToInit()
	
	animateInElement("Logo")
	animateLoopedElement("BG")
	
	await get_tree().create_timer(1).timeout
	
	animateInElement("PlayButton")

func _on_button_pressed() -> void:
	while true:
		pass
