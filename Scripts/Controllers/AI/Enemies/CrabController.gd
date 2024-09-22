extends CharacterBody2D

# Exports #

@export var State : String
@export var States : Array

# Onready #

@onready var AI_Timer : Timer = $AI_Timer

# Var #

# Func #

func update(): # This function will run every 5 seconds, and will be the AI Controller
	pass

# Connectors #

func _ready(): # This function runs when the scene is instantiated
	AI_Timer.start()

func _on_ai_timer_timeout(): # This function runs every time the timer 'AI_Timer' finishes
	update()
