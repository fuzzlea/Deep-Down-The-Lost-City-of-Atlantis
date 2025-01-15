extends Node2D

@onready var plr = $Player

@onready var firstCamPos = $FirstRoom/CameraPos01
@onready var secondCamPos = $FirstRoom/CameraPos02
@onready var thirdCamPos = $FirstRoom/CameraPos03
@onready var fourthCamPos = $FirstRoom/CameraPos04
@onready var fifthCamPos = $FirstRoom/CameraPos05

@onready var button01 = $FirstRoom/TopRightCorner/Button
@onready var button02 = $FirstRoom/Center/Button

@onready var buttonTop = $TopRoom/Button2
@onready var buttonBottom = $BottomRoom/Button

@onready var kelpDoorFirst = $EndHallway/KelpLine01/Kelp3
@onready var kelpDoorSecond = $EndHallway/KelpLine02/Kelp3

@onready var telepad = $EndHallway/Telepad

func _ready():
	
	plr.emit_signal("disableMovement")
	
	SOUNDS.playMusic("underwater ambience")
	
	var ct01 = CAMERA.zoomTo(plr.position, Vector2(7,7))
	await ct01.finished
	
	await get_tree().create_timer(0.5).timeout
	
	var ct02 = CAMERA.zoomTo(firstCamPos.position, Vector2(4,4))
	await ct02.finished
	
	await get_tree().create_timer(0.5).timeout
	
	var ct03 = CAMERA.zoomTo(secondCamPos.position, Vector2(3,3))
	await ct03.finished
	
	await get_tree().create_timer(0.5).timeout
	
	var ct04 = CAMERA.zoomTo(thirdCamPos.position, Vector2(3,3))
	await ct04.finished
	
	await get_tree().create_timer(0.5).timeout
	
	var ct05 = CAMERA.zoomTo(fourthCamPos.position, Vector2(3,3))
	await ct05.finished
	
	await get_tree().create_timer(0.5).timeout
	
	var ct06 = CAMERA.zoomTo(fifthCamPos.position, Vector2(4,4))
	await ct06.finished
	
	await get_tree().create_timer(0.5).timeout
	
	var ct07 = await CAMERA.resetCameraBackToPlayer()
	
	button01.Send.connect(func():
		
		plr.emit_signal("disableMovement")
		
		var ct = CAMERA.zoomTo(button02.position, Vector2(5,5))
		await ct.finished
		
		await get_tree().create_timer(2).timeout
		await CAMERA.resetCameraBackToPlayer()
		
	)
	
	button02.Send.connect(func():
		
		plr.emit_signal("disableMovement")
		
		var ct = CAMERA.zoomTo(secondCamPos.position, Vector2(2,2))
		await ct.finished
		
		await get_tree().create_timer(2).timeout
		
		await CAMERA.resetCameraBackToPlayer()
		
	)
	
	buttonTop.Send.connect(func():
		
		plr.emit_signal("disableMovement")
		
		var ct = CAMERA.zoomTo(kelpDoorSecond.position, Vector2(5,5))
		await ct.finished
		
		await get_tree().create_timer(2).timeout
		
		await CAMERA.resetCameraBackToPlayer()
		
	)
	
	buttonBottom.Send.connect(func():
		
		plr.emit_signal("disableMovement")
		
		var ct = CAMERA.zoomTo(kelpDoorFirst.position, Vector2(5,5))
		await ct.finished
		
		await get_tree().create_timer(2).timeout
		
		await CAMERA.resetCameraBackToPlayer()
		
	)
	
	telepad.Ran.connect(func():
		
		DATA.Data["CurrentPuzzle"] += 1
		
	)
