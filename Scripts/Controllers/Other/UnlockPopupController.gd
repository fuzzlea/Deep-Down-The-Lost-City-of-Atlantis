extends CanvasLayer

@export var item : String = "None"
@export var isRelic : bool = false

@onready var BG : TextureRect = $Background
@onready var SpinWheel : TextureRect = $SpinWheel
@onready var ItemIcon : TextureRect = $ItemIcon
@onready var Title : Label = $Title

func _ready():
	Title.text = "A " + item
	#ItemIcon.texture

func INIT(_item : String, _isRelic : bool):
	item = _item
	isRelic = _isRelic
