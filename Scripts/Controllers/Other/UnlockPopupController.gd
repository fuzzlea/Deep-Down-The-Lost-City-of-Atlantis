extends CanvasLayer

@export var item : String = "None"
@export var isRelic : bool = false

@onready var BG : TextureRect = $Background
@onready var SpinWheel : TextureRect = $SpinWheel
@onready var ItemIcon : TextureRect = $ItemIcon
@onready var Title : Label = $Title
@onready var YouFound : Label = $YouFound

func _ready():
	
	if not isRelic:
		YouFound.text = "You Found..."
		Title.text = "A " + item
		
		ItemIcon.texture = load(INVENTORY.ItemInformation[item]["Image"])
	else:
		YouFound.text = "Relic Unlocked!"
		Title.text = item
		
		ItemIcon.texture = load(DATA.Data["Relics"][item][1])
	
	BG.modulate = Color(1,1,1,0)
	SpinWheel.scale = Vector2(0,0)
	ItemIcon.scale = Vector2(0,0)
	Title.modulate = Color(1,1,1,0)
	YouFound.modulate = Color(1,1,1,0)
	animate()

func animate():
	
	var animateInTween = get_tree().create_tween().set_parallel(true)
	animateInTween.tween_property(BG, "modulate", Color(1,1,1,0.149), 1).set_trans(Tween.TRANS_SINE)
	animateInTween.tween_property(SpinWheel, "scale", Vector2(1,1), 0.25).set_trans(Tween.TRANS_BACK)
	animateInTween.tween_property(ItemIcon, "scale", Vector2(1,1), 0.5).set_trans(Tween.TRANS_BACK)
	animateInTween.tween_property(Title, "modulate", Color(1,1,1,1), 1).set_trans(Tween.TRANS_SINE)
	animateInTween.tween_property(YouFound, "modulate", Color(1,1,1,1), 1).set_trans(Tween.TRANS_SINE)
	
	await animateInTween.finished
	await get_tree().create_timer(1).timeout
	
	var animateOutTween = get_tree().create_tween().set_parallel(true)
	animateOutTween.tween_property(BG, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_SINE)
	animateOutTween.tween_property(SpinWheel, "scale", Vector2(0,0), 0.25).set_trans(Tween.TRANS_BACK)
	animateOutTween.tween_property(ItemIcon, "scale", Vector2(0,0), 0.5).set_trans(Tween.TRANS_BACK)
	animateOutTween.tween_property(Title, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_SINE)
	animateOutTween.tween_property(YouFound, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_SINE)
	
	await animateOutTween.finished
	
	queue_free()
