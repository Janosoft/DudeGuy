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
	if (newEmotion != 'default'): $EmotionTimer.start()

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
	var maxStatus = ''
	var maxValue = -5
	var text= ''
	
	for key in thingStatus.keys():
		if (thingStatus[key] > maxValue):
			maxStatus = key
			maxValue = thingStatus[key]
	
	match maxStatus:
		'Striking':
			text = ["Whoa, check that out, that's weird",
					"Wow, look over there, that's odd",
					"Take a look at that, it's pretty strange",
					"Oh my, what's that? That's unusual",
					"What's that? That's rather peculiar"
					]
		'Aggressiveness':
			if (aggressiveness - (maxValue + _perception) < 0): #SCARY
				text = ["Oh no, that's terrifying!",
						"Yikes, I'm scared!",
						"That's giving me the creeps",
						"I'm getting goosebumps",
						"Oh wow, that's really freaking me out!"
						]
			else: #FRIENDLY
				text = ["Aww, that's so sweet!",
						"How adorable!",
						"Oh, that's just too cute",
						"Look at that, it's heartwarming",
						"That's so precious!"
						]
		'Temperature':
			if (maxValue>0): #WARM
				text = ["Ah, feels nice and warm over here",
						"It's cozy by this warmth",
						"Mmm, I can feel the heat, it's so comforting",
						"This warmth is just what I needed",
						"Oh, it's toasty around here, I love it"
						]
			else: #COLD
				text = ["Brr, it's chilly around here",
						"Feels cold over here, but refreshing",
						"I can feel the coolness, it's quite invigorating",
						"This cold is bracing, but in a good way",
						"It's icy around here, but I don't mind"
						]
		_:
			text = ["Everything seems calm",
					"It looks like everything's quiet",
					"Looks like it's all peaceful",
					"Seems like there's nothing happening",
					"No excitement here, just a quiet moment"
					]
	
	return text[randi() % text.size()]

func checkObject(thing: Object):
	var newEmotion:String = emotionCalculator(thing.status)
	var words:String = talkCalculator(thing.status)
	setEmotion(newEmotion)
	if (!words.is_empty() and newEmotion!='default') :talk(words)

#region Catch Signals#
func _on_hitbox_body_entered(body):
	print_debug("Trasspassing: " + body.name)
	if ('Temperature' in body.status):
		if (body.status['Temperature'] != 0): setTemperature(body.status['Temperature'])
		var words:String = talkCalculator(body.status)
		if (!words.is_empty()) :talk(words)
	if ('Aggressiveness' in body.status):
		if (body.status['Aggressiveness'] > 0): setEmotion('Pain')
		var words:String = talkCalculator(body.status)
		if (!words.is_empty()) :talk(words)
	
func _on_hitbox_body_exited(body):
	#print_debug("Leaving: " + body.name)
	if ('temperature' in body):
		if (body.temperature != 0): setTemperature(_lastTemperature)
	if ('aggressiveness' in body):
		if (body.aggressiveness > 0): setEmotion(_lastEmotion)
#endregion

func _on_emotion_timer_timeout():
	setEmotion('default')
