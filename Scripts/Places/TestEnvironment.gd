extends Node2D

@onready var dude_guy = $DudeGuy
const territoryTypes = {'HOSTILE': -5, 'NEUTRAL': 0, 'FRIENDLY': 5}
var territoryType = territoryTypes.get('NEUTRAL')
var temperature = -2

func _ready():
	dude_guy.setPerception(territoryType)
	dude_guy.setTemperature(temperature)
	dude_guy.emotion('Love')
	dude_guy.talk("Hello Moto")
	
