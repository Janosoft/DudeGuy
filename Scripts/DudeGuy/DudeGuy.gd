extends CharacterBody2D

#region Public Variables
signal talkingSignal
var dialogs : Dictionary = {}
#endregion

#region Privated Variables
@onready var _body = $Body
@onready var _emotion_timer = $EmotionTimer
var _temperature : int = 0
var _lastTemperature : int = 0
var _actualEmotion : String = 'default'
var _lastEmotion : String = 'default'
#endregion

func _ready():
	setEmotion(_actualEmotion)
	
func talk(words: String):
	emit_signal('talkingSignal', words)
	if (!_emotion_timer.is_stopped()):
		_emotion_timer.stop()
		_emotion_timer.wait_time = len(words) * 0.17
		_emotion_timer.start()
	_body.talk(words)

func setEmotion(newEmotion: String):
	_lastEmotion = _actualEmotion
	_body.setEmotion(newEmotion)
	if (newEmotion != 'default'):
		_emotion_timer.start()

func setTemperature(newTemperature: int):
	_lastTemperature= _temperature
	_temperature= newTemperature
	_body.setTemperature(_temperature)

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
			if (maxValue > 0):
				emotion = 'Scared'
			else:
				emotion = 'Happy'
		_:
			emotion = 'default'
	
	return emotion

func talkCalculator(thingStatus: Dictionary)-> String :
	var maxStatus = ''
	var maxValue = -5
	
	for key in thingStatus.keys():
		if (thingStatus[key] > maxValue):
			maxStatus = key
			maxValue = thingStatus[key]
	
	#int(maxValue>0) allows to get more than an atribute and get 0 or 1 in the dialogs
	#randi() % dialogs[maxStatus][int(maxValue>0)].size() takes an random text
	return dialogs[maxStatus][int(maxValue>0)][randi() % dialogs[maxStatus][int(maxValue>0)].size()]

func checkObject(thing: Object):
	#print_debug(thing.name)
	if ('status' in thing):
		var newEmotion:String = emotionCalculator(thing.status)
		var words:String = talkCalculator(thing.status)
		setEmotion(newEmotion)
		if (!words.is_empty() and newEmotion!='default') :talk(words)

#region Catch Signals#
func _on_hitbox_body_entered(body):
	#print_debug("Trasspassing: " + body.name)
	if ('Temperature' in body.status):
		if (body.status['Temperature'] != 0): setTemperature(body.status['Temperature'])
		var words:String = talkCalculator(body.status)
		if (!words.is_empty()) :talk(words)
	if ('Aggressiveness' in body.status):
		if (body.status['Aggressiveness'] > 0):
			setEmotion('Pain')
		else:
			setEmotion('Happy')
		var words:String = talkCalculator(body.status)
		if (!words.is_empty()) :talk(words)
	
func _on_hitbox_body_exited(body):
	#print_debug("Leaving: " + body.name)
	if ('temperature' in body):
		if (body.temperature != 0): setTemperature(_lastTemperature)
	if ('aggressiveness' in body):
		if (body.aggressiveness > 0): setEmotion(_lastEmotion)

func _on_emotion_timer_timeout():
	setEmotion('default')

#endregion
