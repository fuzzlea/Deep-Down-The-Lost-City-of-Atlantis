extends RigidBody2D

@export var KelpLineNode : Node2D
@export var KelpImagePath : String = "res://Assets/Singles (Misc)/Puzzle Mechanics/Recievers/Kelp.png"

@onready var Particles : CPUParticles2D = $CPUParticles2D
@onready var Sprite : Sprite2D = $Sprite2D

var Cuttables = [
	"Crab",
	"AquaLobber"
]

var KelpLine : Array

func deleteKelp(kelp : RigidBody2D):
	kelp.queue_free()

func playParticles(where : RigidBody2D):
	var cpuParticle : CPUParticles2D = where.get_child(0)
	cpuParticle.emitting = true
	cpuParticle.finished.connect(deleteKelp.bind(where))

func cut(_whatCut):
	if KelpLine.size() > 0:
		for kelp : RigidBody2D in KelpLine:
			playParticles(kelp)
			kelp.get_child(1).visible = false
	else: Sprite.visible = false
	
	#var tween = CAMERA.zoomTo(global_position, Vector2(4,4), {"Time": 1, "Transition": Tween.TRANS_SINE})
	#
	#await tween.finished
	#
	#CAMERA.resetCameraBackToPlayer()

func _ready():
	if KelpLineNode:
		KelpLine = KelpLineNode.get_children()
		Sprite.texture = load(KelpImagePath)

func _on_hit_range_area_entered(area: Area2D) -> void:
	var parentOfCollider = area.get_parent()
	
	if Cuttables.find(parentOfCollider.name) >= 0 && KelpLineNode:
		cut(parentOfCollider)
		
		match parentOfCollider.name:
			"AquaLobber":
				parentOfCollider.emit_signal("popBubble")
				return
			_:
				pass
