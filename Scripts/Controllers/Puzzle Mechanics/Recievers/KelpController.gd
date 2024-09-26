extends RigidBody2D

@export var KelpLineNode : Node2D

var Cuttables = [
	"Crab"
]

var KelpLine : Array

func playParticles(where):
	pass

func cut(_whatCut):
	if KelpLine.size() > 0:
		for kelp : RigidBody2D in KelpLine:
			kelp.queue_free()
	else: queue_free()

func _ready():
	if KelpLineNode:
		KelpLine = KelpLineNode.get_children()

func _on_hit_range_area_entered(area: Area2D) -> void:
	var parentOfCollider = area.get_parent()
	
	if Cuttables.find(parentOfCollider.name) >= 0 && KelpLineNode:
		cut(parentOfCollider)
