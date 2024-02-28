extends CharacterBody2D

@onready var _body = $Body

#region Status
var _perception : int = 0
var temperature : int = 0
var aggressiveness : int = 0
#endregion

var _actualEmotion : String = 'default'
var _lastTemperature : int = 0

func _ready():
	emotion(_actualEmotion)
	
func talk(words: String):
	_body.talk(words)

func emotion(newEmotion: String):
	_body.emotion(newEmotion)

func setTemperature(newTemperature: int):
	_lastTemperature= temperature
	temperature= newTemperature
	_body.setTemperature(temperature)

func setPerception(newPerception: int):
	#It's diferent interact to something in a hostile place than a friendly one
	_perception= newPerception

func checkObject(thing: Object):
	if ('aggressiveness' in thing):
		if (aggressiveness - (thing.aggressiveness + _perception) < 0):
			print_debug(aggressiveness - (thing.aggressiveness + _perception))
			emotion("Scared")
			talk("Ohh my God")
	else:
		print_debug('Not aggressiveness')

func _on_hitbox_body_entered(body):
	print_debug("Trasspassing: " + body.name)
	if ('temperature' in body):
		setTemperature(body.temperature)

func _on_hitbox_body_exited(body):
	print_debug("Leaving: " + body.name)
	if ('temperature' in body):
		setTemperature(_lastTemperature)
