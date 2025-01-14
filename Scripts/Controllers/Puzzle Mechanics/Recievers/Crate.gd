extends RigidBody2D

# ONREADY

@onready var CrateSprite = $Sprite2D
@onready var Particles = $CPUParticles2D

# VAR

var Breakables : Array = [
	"AquaLobber"
]

# FUNC

# This function will break the crate, emitting particles to give a more convincing look to the break of the crate
func breakSelf(_whatBroke):
	collision_layer = 0
	collision_mask = 0
	
	CrateSprite.visible = false
	
	Particles.emitting = true
	Particles.finished.connect(func():
		queue_free()
	)

# CONNECTOR

# Checks if whatever is in range of the crate is able to break the crate, and react accordingly
func _on_hit_range_area_entered(area: Area2D) -> void:
	var parentOfCollider = area.get_parent()
	
	if Breakables.find(parentOfCollider.name) >= 0:
		breakSelf(parentOfCollider)
		
		match parentOfCollider.name:
			"AquaLobber":
				parentOfCollider.emit_signal("popBubble")
			_:
				pass
