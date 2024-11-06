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
		get_tree().change_scene_to_packed(newScene)
		
		await get_tree().create_timer(10).timeout
		await tweenBGOut().finished
		
		self.queue_free()
