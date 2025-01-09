extends Node

@export var Data = {
	"SFX": {
		"ui_click01" : {"Stream": "res://Sounds/SFX/casual-click-pop-ui-3-262120.mp3", "Volume": -4.0},
		"ui_tick01" : {"Stream": "res://Sounds/SFX/light-switch-flip-272436.mp3", "Volume": -4.0},
		
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
	"Music": {}
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
	if not Data["SFX"].has(what.to_lower()): print('nf'); return
	
	var newAudio = AudioStreamPlayer2D.new()
	get_child(0).add_child(newAudio)
	
	newAudio.volume_db = SFXVol + Data["SFX"][what.to_lower()]["Volume"]
	newAudio.stream = load(Data["SFX"][what.to_lower()]["Stream"])
	newAudio.name = what + str(SFXVol)
	
	newAudio.play()
	newAudio.finished.connect(func(): newAudio.queue_free())

func playMusic(what : String):
	pass
