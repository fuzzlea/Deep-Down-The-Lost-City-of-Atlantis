extends CanvasLayer

@export_file("*.tscn") var nextScenePath : String

@onready var BG : TextureRect = $BG

@onready var Boat : TextureRect = $Boat
@onready var BoatAnimations = $BoatAnimations

func tweenBGIn():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(BG, "modulate", Color(1,1,1,1), 1)
	return tween

func tweenBGOut():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(BG, "modulate", Color(1,1,1,0), 1)
	
	return tween

func tweenBoatOut():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(Boat, "position", Vector2(Boat.position.x, Boat.position.y + 200), 2)
	
	return tween

func tweenBoat():
	BoatAnimations.play("BoatDrive")

func _ready():
	BG.modulate = Color(1,1,1,0)
	
	await tweenBGIn().finished
	
	tweenBoat()
	
	ResourceLoader.load_threaded_request(nextScenePath)

func _process(_delta: float):
	if ResourceLoader.load_threaded_get_status(nextScenePath) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		
		var newScene : PackedScene = ResourceLoader.load_threaded_get(nextScenePath)
		
		get_tree().unload_current_scene()
		
		await get_tree().create_timer(3).timeout
		
		BoatAnimations.stop(true)
		
		await tweenBoatOut().finished
		
		get_tree().change_scene_to_packed(newScene)
		
		await tweenBGOut().finished
		await get_tree().create_timer(0.2).timeout
		
		self.queue_free()
