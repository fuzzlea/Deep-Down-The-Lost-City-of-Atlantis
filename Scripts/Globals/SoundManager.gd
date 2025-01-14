extends Node

# EXPORT 

@export var Data = {
	"SFX": {
		
		# ui
		
		"ui_click01" : {"Stream": "res://Sounds/SFX/casual-click-pop-ui-3-262120.mp3", "Volume": -12.0},
		"ui_tick01" : {"Stream": "res://Sounds/SFX/light-switch-flip-272436.mp3", "Volume": -12.0},
		"ui_swoop" : {"Stream": "res://Sounds/SFX/swing-whoosh-11-198503.mp3", "Volume": 2.0},
		"ui_droop" : {"Stream": "res://Sounds/SFX/sci-fi-bubble-pop-89059-[AudioTrimmer.com]-2.mp3", "Volume": -3.0},
		"ui_pop" : {"Stream": "res://Sounds/SFX/multi-pop-1-188165-[AudioTrimmer.com].mp3", "Volume": -3.0},
		"ui_lettertick": {"Stream": "res://Sounds/SFX/letter tick.mp3", "Volume": -5.0},
		
		# other
		
		"tp" : {"Stream": "res://Sounds/SFX/bubbles-108320.mp3", "Volume": -12.0},
		"button_click" : {"Stream": "res://Sounds/SFX/old-radio-button-click-97549.mp3", "Volume": -6.0},
		"kelp_cut": {"Stream": "res://Sounds/SFX/plastic-crunch-83779.mp3", "Volume": 0.0},
		"item_found": {"Stream": "res://Sounds/SFX/level-up-4-243762.mp3", "Volume": -5.0},
		"boat_toot": {"Stream": "res://Sounds/SFX/toot_toot.mp3", "Volume": -13.0},
		
		# footsteps
		
		"foot1": {"Stream": "res://Sounds/SFX/Footsteps/foot1.mp3", "Volume": 0.0},
		"foot2": {"Stream": "res://Sounds/SFX/Footsteps/foot2.mp3", "Volume": 0.0},
		"foot3": {"Stream": "res://Sounds/SFX/Footsteps/foot3.mp3", "Volume": 0.0},
		"foot4": {"Stream": "res://Sounds/SFX/Footsteps/foot4.mp3", "Volume": 0.0},
		"foot5": {"Stream": "res://Sounds/SFX/Footsteps/foot5.mp3", "Volume": 0.0},
		"foot6": {"Stream": "res://Sounds/SFX/Footsteps/foot6.mp3", "Volume": 0.0},
		"foot7": {"Stream": "res://Sounds/SFX/Footsteps/foot7.mp3", "Volume": 0.0},
		"foot8": {"Stream": "res://Sounds/SFX/Footsteps/foot8.mp3", "Volume": 0.0},
		"foot9": {"Stream": "res://Sounds/SFX/Footsteps/foot9.mp3", "Volume": 0.0},
		"foot10": {"Stream": "res://Sounds/SFX/Footsteps/foot10.mp3", "Volume": 0.0},
		"foot11": {"Stream": "res://Sounds/SFX/Footsteps/foot11.mp3", "Volume": 0.0}
	},
	"Music": {
		"underwater ambience": {"Stream": "res://Sounds/Music/underwater ambience.mp3", "Volume": -10.0},
		"menu music": {"Stream": "res://Sounds/Music/sound-on-dreammp3-271820.mp3", "Volume": -8.0},
		"loadingscreen bubbles": {"Stream": "res://Sounds/SFX/water-bubbles-257594.mp3", "Volume": -15.0}
	}
}

@export var SFXVol : float = 0.0
@export var MusicVol : float = 0.0

# FUNC

# This function plays a sound effect
func playSound(what : String, randpitch : bool = false):
	if not Data["SFX"].has(what.to_lower()): return
	
	var newAudio = AudioStreamPlayer2D.new()
	get_child(0).add_child(newAudio)
	
	newAudio.volume_db = SFXVol + Data["SFX"][what.to_lower()]["Volume"]
	newAudio.stream = load(Data["SFX"][what.to_lower()]["Stream"])
	newAudio.name = what + str(SFXVol)
	
	if randpitch:
		newAudio.pitch_scale = randf_range(0.9,1.1)
	
	newAudio.play()
	newAudio.finished.connect(func(): newAudio.queue_free())

# This function plays music
func playMusic(what : String):
	if not Data["Music"].has(what.to_lower()): return
	
	if get_child(1).find_child(what.to_lower(), true, false):
		fadeMusic(what)
	
	var newAudio = AudioStreamPlayer2D.new()
	get_child(1).add_child(newAudio)
	
	newAudio.volume_db = Data["Music"][what.to_lower()]["Volume"]
	newAudio.stream = load(Data["Music"][what.to_lower()]["Stream"])
	newAudio.name = what.to_lower()
	
	newAudio.play()

# This function will fade a given song out
func fadeMusic(what: String):
	var fadeOut = get_tree().create_tween()
	fadeOut.tween_property(get_child(1).find_child(what.to_lower(), true, false), "volume_db", -100.0, 3)
	fadeOut.tween_callback(func(): if get_child(1).find_child(what.to_lower(), true, false): get_child(1).find_child(what.to_lower(), true, false).queue_free())

# This function will fade out all the music in the scene
func fadeAll():
	if not get_child(1).get_children().is_empty():
		for music in get_child(1).get_children():
			fadeMusic(music.name)

# This function will pause all the music playing
func pauseMusic():
	if not get_child(1).get_children().is_empty():
		for music : AudioStreamPlayer2D in get_child(1).get_children():
			music.stream_paused = true

# This function will resume all of the paused music
func resumeMusic():
	if not get_child(1).get_children().is_empty():
		for music : AudioStreamPlayer2D in get_child(1).get_children():
			music.stream_paused = false

# CONNECTOR

# This function will run when the application initializes the sound manager script
func _init():
	
	process_mode = PROCESS_MODE_ALWAYS
	
	var sfxNode = Node.new()
	var musicNode = Node.new()
	
	sfxNode.name = "SFX"
	musicNode.name = "Music"
	
	add_child(sfxNode)
	add_child(musicNode)
