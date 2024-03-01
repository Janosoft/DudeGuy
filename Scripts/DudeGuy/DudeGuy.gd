extends CharacterBody2D

@onready var _body = $Body

#region Status
var _perception : int = 0
var temperature : int = 0
var aggressiveness : int = 0
#endregion

var _actualEmotion : String = 'default'
var _lastEmotion : String = 'default'
var _lastTemperature : int = 0

func _ready():
	setEmotion(_actualEmotion)
	
func talk(words: String):
	_body.talk(words)

func setEmotion(newEmotion: String):
	_lastEmotion = _actualEmotion
	_body.setEmotion(newEmotion)
	$EmotionTimer.start()

func setTemperature(newTemperature: int):
	_lastTemperature= temperature
	temperature= newTemperature
	_body.setTemperature(temperature)

func setPerception(newPerception: int):
	#It's diferent interact to something in a hostile place than a friendly one
	_perception= newPerception

func emotionCalculator(thingStatus: Dictionary)-> String :
	var maxStatus = ''
	var maxValue = -5
	var emotion = 'default'
	
	for key in thingStatus.keys():
		if (thingStatus[key] > maxValue):
			maxStatus = key
			maxValue = thingStatus[key]
	
	match maxStatus:
		'Striking':
			emotion = "Wonder"
		'Aggressiveness':
			if (aggressiveness - (maxValue + _perception) < 0):
				emotion = 'Scared'
		_:
			emotion = 'default'
	
	return emotion

func talkCalculator(thingStatus: Dictionary)-> String :
	return 'Ohh my God'

func checkObject(thing: Object):
	var newEmotion:String = emotionCalculator(thing.status)
	var words:String = talkCalculator(thing.status)
	setEmotion(newEmotion)
	if (!words.is_empty()) :talk(words)

#region Catch Signals#
func _on_hitbox_body_entered(body):
	#print_debug("Trasspassing: " + body.name)
	if ('Temperature' in body.status):
		if (body.status['Temperature'] != 0): setTemperature(body.status['Temperature'])
	if ('Aggressiveness' in body.status):
		if (body.status['Aggressiveness'] > 0): setEmotion('Pain')

func _on_hitbox_body_exited(body):
	#print_debug("Leaving: " + body.name)
	if ('temperature' in body):
		if (body.temperature != 0): setTemperature(_lastTemperature)
	if ('aggressiveness' in body):
		if (body.aggressiveness > 0): setEmotion(_lastEmotion)
#endregion

func _on_emotion_timer_timeout():
	setEmotion('default')
