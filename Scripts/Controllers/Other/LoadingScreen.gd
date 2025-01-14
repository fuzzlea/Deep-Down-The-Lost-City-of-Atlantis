extends CanvasLayer

# EXPORT

@export_file("*.tscn") var nextScenePath : String

# ONREADY

@onready var BG : TextureRect = $BG
@onready var Boat : TextureRect = $Boat
@onready var BoatAnimations = $BoatAnimations

# FUNC

# This function tweens the background in
func tweenBGIn():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(BG, "modulate", Color(1,1,1,1), 1)
	return tween

# This function tweens the background out
func tweenBGOut():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(BG, "modulate", Color(1,1,1,0), 1)
	
	return tween

# This function tweens the boat out
func tweenBoatOut():
	SOUNDS.fadeAll()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(Boat, "position", Vector2(Boat.position.x, Boat.position.y + 200), 2)
	
	return tween

# This function begins the Boat Driving Animation
func tweenBoat():
	BoatAnimations.play("BoatDrive")

# CONNECTORS

# This function runs when the loading screen is instantiated
func _ready():
	BG.modulate = Color(1,1,1,0)
	
	SOUNDS.fadeAll()
	
	await tweenBGIn().finished
	
	tweenBoat()
	
	SOUNDS.playMusic("loadingscreen bubbles")
	
	ResourceLoader.load_threaded_request(nextScenePath)

# This function runs every frame, checking for when the next scene is ready to be loaded. When the next scene is ready to be loaded, a series of animations / sounds are played to spice up the loading screen
func _process(_delta: float):
	if ResourceLoader.load_threaded_get_status(nextScenePath) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		
		var newScene : PackedScene = ResourceLoader.load_threaded_get(nextScenePath)
		
		if get_tree().current_scene: get_tree().unload_current_scene()
		
		DATA.emit_signal("SAVE_DATA")
		
		await get_tree().create_timer(1.5).timeout
		
		BoatAnimations.stop(true)
		
		get_tree().create_timer(0.1).timeout.connect(func(): SOUNDS.playSound("boat_toot"))
		
		await tweenBoatOut().finished
		
		get_tree().change_scene_to_packed(newScene)
		
		await tweenBGOut().finished
		await get_tree().create_timer(0.2).timeout
		
		self.queue_free()
	else:
		pass
