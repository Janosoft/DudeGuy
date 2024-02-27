extends Node2D

@onready var dude_guy = $DudeGuy
var temperature = 5

func _ready():
	dude_guy.setTemperature(temperature)
	dude_guy.talk("Hello Moto")
