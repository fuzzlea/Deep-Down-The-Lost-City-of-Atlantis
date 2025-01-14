extends RigidBody2D

# SIGNAL

@warning_ignore("unused_signal")
signal Recieve

# EXPORTS

@export var KelpLineNode : Node2D
@export var KelpImagePath : String = "res://Assets/Singles (Misc)/Puzzle Mechanics/Recievers/Kelp.png"

# ONREADY

@onready var Particles : CPUParticles2D = $CPUParticles2D
@onready var Sprite : Sprite2D = $Sprite2D

# VAR

var Cuttables = [
	"Crab",
	"AquaLobber"
]

var KelpLine : Array

# FUNC

# This function deletes the kelp
func deleteKelp(kelp : RigidBody2D):
	kelp.queue_free()

# Plays the kelp particles
func playParticles(where : RigidBody2D):
	var cpuParticle : CPUParticles2D = where.get_child(0)
	
	cpuParticle.emitting = true
	cpuParticle.finished.connect(deleteKelp.bind(where))

# Cut the kelp
func cut(_whatCut):
	SOUNDS.playSound("kelp_cut")
	if KelpLine.size() > 0:
		for kelp : RigidBody2D in KelpLine:
			kelp.collision_layer = 0
			kelp.collision_mask = 0
			kelp.get_child(1).visible = false
			
			playParticles(kelp)
	else: Sprite.visible = false

# Updates the texture to the [KelpImagePath] texture
func _ready():
	if KelpLineNode:
		KelpLine = KelpLineNode.get_children()
		Sprite.texture = load(KelpImagePath)

# This function will check if anything that can cut the kelp is in range, and react accordingly
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

# This function will run whenever the signal 'Recieve' is emitted
func _on_recieve() -> void:
	print("Recieved")
	cut("n/a")
