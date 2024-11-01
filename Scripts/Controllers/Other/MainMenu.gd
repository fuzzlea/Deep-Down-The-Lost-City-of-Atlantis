extends Control

@onready var Logo : TextureRect = $Logo
@onready var AnimPlayer : AnimationPlayer = $AnimationPlayer

func resetAllElementsToInit():
	Logo.position = Vector2(479.5, -400)

func animateInElement(elementName : String):
	match elementName:
		"Logo":
			var logo_tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			logo_tween.tween_property(Logo, "position", Vector2(479.5,0),2)
			logo_tween.tween_callback(func(): animateLoopedElement("Logo"))

func animateLoopedElement(elementName : String):
	match elementName:
		"Logo":
			AnimPlayer.play("LogoBobLoop")

func _ready():
	resetAllElementsToInit()
	animateInElement("Logo")
