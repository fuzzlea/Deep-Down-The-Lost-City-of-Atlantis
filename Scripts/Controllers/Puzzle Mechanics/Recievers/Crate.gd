extends RigidBody2D

@onready var CrateSprite = $Sprite2D
@onready var Particles = $CPUParticles2D

var Breakables : Array = [
	"AquaLobber"
]

func breakSelf(_whatBroke):
	collision_layer = 0
	collision_mask = 0
	
	CrateSprite.visible = false
	
	Particles.emitting = true
	Particles.finished.connect(func():
		queue_free()
	)

func _on_hit_range_area_entered(area: Area2D) -> void:
	var parentOfCollider = area.get_parent()
	
	if Breakables.find(parentOfCollider.name) >= 0:
		breakSelf(parentOfCollider)
		
		match parentOfCollider.name:
			"AquaLobber":
				parentOfCollider.emit_signal("popBubble")
			_:
				pass
