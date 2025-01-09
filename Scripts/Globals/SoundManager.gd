extends Node

@export var Data = {
	"SFX": {
		
		# ui
		
		"ui_click01" : {"Stream": "res://Sounds/SFX/casual-click-pop-ui-3-262120.mp3", "Volume": -8.0},
		"ui_tick01" : {"Stream": "res://Sounds/SFX/light-switch-flip-272436.mp3", "Volume": -8.0},
		"ui_swoop" : {"Stream": "res://Sounds/SFX/swing-whoosh-11-198503.mp3", "Volume": 2.0},
		"ui_droop" : {"Stream": "res://Sounds/SFX/sci-fi-bubble-pop-89059-[AudioTrimmer.com]-2.mp3", "Volume": -3.0},
		"ui_pop" : {"Stream": "res://Sounds/SFX/multi-pop-1-188165-[AudioTrimmer.com].mp3", "Volume": -3.0},
		
		# other
		
		"tp" : {"Stream": "res://Sounds/SFX/bubbles-108320.mp3", "Volume": -12.0},
		
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
		"menu music": {"Stream": "res://Sounds/Music/sound-on-dreammp3-271820.mp3", "Volume": -8.0}
	}
}

@export var SFXVol : float = 0.0
@export var MusicVol : float = 0.0

func _init():
	
	process_mode = PROCESS_MODE_ALWAYS
	
	var sfxNode = Node.new()
	var musicNode = Node.new()
	
	sfxNode.name = "SFX"
	musicNode.name = "Music"
	
	add_child(sfxNode)
	add_child(musicNode)

func playSound(what : String):
	if not Data["SFX"].has(what.to_lower()): return
	
	var newAudio = AudioStreamPlayer2D.new()
	get_child(0).add_child(newAudio)
	
	newAudio.volume_db = SFXVol + Data["SFX"][what.to_lower()]["Volume"]
	newAudio.stream = load(Data["SFX"][what.to_lower()]["Stream"])
	newAudio.name = what + str(SFXVol)
	
	newAudio.play()
	newAudio.finished.connect(func(): newAudio.queue_free())

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

func fadeMusic(what: String):
	var fadeOut = get_tree().create_tween()
	fadeOut.tween_property(get_child(1).find_child(what.to_lower(), true, false), "volume_db", -100.0, 3)
	fadeOut.tween_callback(func(): get_child(1).find_child(what.to_lower(), true, false).queue_free())

func fadeAll():
	if not get_child(1).get_children().is_empty():
		for music in get_child(1).get_children():
			fadeMusic(music.name)

func pauseMusic():
	if not get_child(1).get_children().is_empty():
		for music : AudioStreamPlayer2D in get_child(1).get_children():
			music.stream_paused = true

func resumeMusic():
	if not get_child(1).get_children().is_empty():
		for music : AudioStreamPlayer2D in get_child(1).get_children():
			music.stream_paused = false
