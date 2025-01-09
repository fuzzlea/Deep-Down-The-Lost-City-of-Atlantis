extends Node

@export var Data = {
	"SFX": {
		"ui_click01" : {"Stream": "res://Sounds/SFX/casual-click-pop-ui-3-262120.mp3", "Volume": -4.0},
		"ui_tick01" : {"Stream": "res://Sounds/SFX/light-switch-flip-272436.mp3", "Volume": -4.0},
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
