extends Node2D

@onready var dude_guy = $DudeGuy
const territoryTypes = {'HOSTILE': -1, 'NEUTRAL': 0, 'FRIENDLY': 1}
var territoryType = territoryTypes.get('NEUTRAL')
var temperature = 0

func _ready():
	dude_guy.setPerception(territoryType)
	dude_guy.setTemperature(temperature)
