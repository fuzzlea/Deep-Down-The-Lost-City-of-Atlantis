extends Area2D

# SIGNAL

signal Interact

# EXPORTS

@export_enum("0","1","2","3","4") var PotNumber : int = 1
@export_enum(" ", "Detailed", "Golden") var PotType : String = ""

@export var Item : String
@export var IsRelic : bool
@export var Opened : bool = false

# ONREADY

@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var collectible = preload("res://Scenes/Singles (Misc)/Collectable.tscn")

# FUNC

# This function runs when the pot is interacted with
func interact():
	anim.play("shake")
	
	if Opened: return
	if not Item: return
	
	Opened = true
	
	var newCol = collectible.instantiate()
	get_tree().current_scene.add_child(newCol)
	
	newCol.set_meta("CollectableName", Item)
	newCol.set_meta("IsRelic", IsRelic)
	
	newCol.scale = Vector2(0,0)
	newCol.position = position
	
	var tween = get_tree().create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(newCol,"scale",Vector2(1,1),0.25)
	tween.tween_property(newCol,"position", position + Vector2(0,-3), 0.1)
	
	newCol.position = position + Vector2(0,-20)
	newCol.z_index = z_index
	newCol.texture = load(INVENTORY.ItemInformation[Item]["Image"])

# CONNECTORS

# This function sets the texture to the correct one according to the [PotType] & [PotNumber]
func _ready() -> void:
	if PotType == " ":
		sprite.texture = load("res://Assets/Environment/Pot" + str(PotNumber) + ".png")
	else:
		sprite.texture = load("res://Assets/Environment/" + PotType + "Pot" + str(PotNumber) + ".png")

# This function connects the Interaction signal to the interaction function
func _on_interact() -> void:
	interact()
