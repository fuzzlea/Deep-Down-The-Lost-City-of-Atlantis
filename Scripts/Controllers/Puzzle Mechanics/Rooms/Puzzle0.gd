extends Node2D

@onready var World = $TileMap
@onready var Player = $Player
@onready var Kelp = $KelpLine
@onready var Crab = $Crab

var LoadingScreen

var crabReachedKelp : bool = false:
	set(val):
		if val == true:
			
			var zoomTween = CAMERA.zoomTo(Vector2(365,330), Vector2(4,4), {"Time": 1.2, "Transition": Tween.TRANS_SINE})
			
			await zoomTween.finished
			
			await get_tree().create_timer(1).timeout
			
			CAMERA.resetCameraBackToPlayer()

func _ready():
	
	Player.emit_signal("disableMovement")
	Crab.emit_signal("disableMovement")
	
	await get_tree().create_timer(7).timeout
	
	var firstTween = CAMERA.zoomTo(Vector2(177,255), Vector2(5,5), {"Time": 1.5, "Transition": Tween.TRANS_SINE})
	
	await firstTween.finished
	await get_tree().create_timer(0.5).timeout
	
	var secondTween = CAMERA.zoomTo(Vector2(378,302), Vector2(4,4), {"Time": 1.5, "Transition": Tween.TRANS_SINE})
	
	await secondTween.finished
	await get_tree().create_timer(0.5).timeout
	
	CAMERA.resetCameraBackToPlayer()
	
	Crab.emit_signal("enableMovement")
	Player.emit_signal("enableMovement")

func _process(_delta: float) -> void:
	if Crab.global_position.x >= 378:
		set_process(false)
		crabReachedKelp = true
		return
