extends CharacterBody2D

#region Public Variables
signal talkingSignal
@export var bodyVisible: bool = true
var dialogs : Dictionary = {}
var emotions : Dictionary = {}
var actionsOnHit : Dictionary = {}
var actionsOnLeaveHit : Dictionary = {}
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
	if (!bodyVisible): _body.hideBody()
	setEmotion(_actualEmotion)
	
func talk(words: String):
	emit_signal('talkingSignal', words) #used to display dialog in some TextBox
	if (!_emotion_timer.is_stopped()):
		_emotion_timer.stop()
		_emotion_timer.wait_time = len(words) * 0.17 # 0.17 is the animation speed of each letter
		_emotion_timer.start()
	_body.talk(words)

func setEmotion(newEmotion: String):
	_lastEmotion = _actualEmotion #to return to the previous state after a while
	_body.setEmotion(newEmotion)
	if (newEmotion != 'default'):
		_emotion_timer.start()

func setTemperature(newTemperature: String):
	_lastTemperature = int(_temperature) #to be able to return to the previous state
	_temperature = int(newTemperature)
	_body.setTemperature(_temperature)

func revertTemperature():
	_body.setTemperature(_lastTemperature)

func emotionCalculator(thingStatus: Dictionary)-> String :
	#calculates the emotion according to what is established in the array of status -> emotion provided by the world
	var maxStatus = ''
	var maxValue = -100
	
	for key in thingStatus.keys():
		if (thingStatus[key] > maxValue):
			maxStatus = key
			maxValue = thingStatus[key]
	
	#int(maxValue>0) allows to get more than an atribute and get 0 or 1 in the emotions
	#randi() % emotions[maxStatus][int(maxValue>0)].size() takes an random text
	if (maxStatus in emotions.keys()):
		return emotions[maxStatus][int(maxValue>0)][randi() % emotions[maxStatus][int(maxValue>0)].size()]
	else:
		return 'default'

func talkCalculator(thingStatus: Dictionary)-> String :
	#calculates the dialog according to what is established in the array of status -> dialog provided by the world
	var maxStatus = ''
	var maxValue = -100
	
	for key in thingStatus.keys():
		if (thingStatus[key] > maxValue):
			maxStatus = key
			maxValue = thingStatus[key]
	
	#int(maxValue>0) allows to get more than an atribute and get 0 or 1 in the dialogs
	#randi() % dialogs[maxStatus][int(maxValue>0)].size() takes an random text
	return dialogs[maxStatus][int(maxValue>0)][randi() % dialogs[maxStatus][int(maxValue>0)].size()]

func actionOnHitCalculator(thingStatus: Dictionary):
	#calculates the function to execute according to what is established in the array of status -> function,parameter provided by the world
	var maxStatus = ''
	var maxValue = -100
	
	for key in thingStatus.keys():
		if (thingStatus[key] > maxValue):
			maxStatus = key
			maxValue = thingStatus[key]
	
	if (maxStatus in actionsOnHit):
		#print_debug(maxStatus)
		if (int(maxValue>0) in actionsOnHit[maxStatus]):
			var funcName = 0
			var funcParams = 1
			if (funcName >= 0 && funcName < actionsOnHit[maxStatus].size()): #Function exists in actions?
				var callable = Callable(self, actionsOnHit[maxStatus][int(maxValue>0)][funcName])
				if (funcParams >= 0 && funcParams < actionsOnHit[maxStatus][int(maxValue>0)].size()): #Params exists in actions?
					callable.call(actionsOnHit[maxStatus][int(maxValue>0)][funcParams])
				else: #Run without params
					callable.call()
			else:
				#print_debug('action doesnt have a function... do nothing')
				pass
		else:
			#print_debug(actionsOnHit[maxStatus])
			#print_debug('action doesnt exist... do nothing')
			pass
	
func actionOnLeaveHitCalculator(thingStatus: Dictionary):
	#calculates the function to execute according to what is established in the array of status -> function,parameter provided by the world
	var maxStatus = ''
	var maxValue = -100
	
	for key in thingStatus.keys():
		if (thingStatus[key] > maxValue):
			maxStatus = key
			maxValue = thingStatus[key]
	
	if (maxStatus in actionsOnLeaveHit):
		if (maxValue in actionsOnLeaveHit[maxStatus]):
			var funcName = 0
			var funcParams = 1
			if (funcName >= 0 && funcName < actionsOnLeaveHit[maxStatus].size()): #Function exists in actions?
				var callable = Callable(self, actionsOnLeaveHit[maxStatus][maxValue][funcName])
				if (funcParams >= 0 && funcParams < actionsOnLeaveHit[maxStatus][maxValue].size()): #Params exists in actions?
					callable.call(actionsOnLeaveHit[maxStatus][maxValue][funcParams])
				else: #Run without params
					callable.call()
			else:
				print_debug('action doesnt have a function... do nothing')
		else:
			print_debug('action doesnt exist... do nothing')

func checkObject(thing: Object):
	#used by the eyes to act accordingly to what is seen
	if ('status' in thing):
		var newEmotion:String = emotionCalculator(thing.status)
		var words:String = talkCalculator(thing.status)
		setEmotion(newEmotion)
		if (!words.is_empty() and newEmotion!='default') :talk(words)

#region Catch Signals#
func _on_hitbox_body_entered(body):
	#runs dynamic action
	#print_debug("Trasspassing: " + body.name)
	#print_debug("Action: " + body.status)
	if ("status" in body): actionOnHitCalculator(body.status)
	
func _on_hitbox_body_exited(body):
	#runs dynamic action
	#print_debug("Trasspassing: " + body.name)
	#print_debug("Action: " + body.status)
	if ("status" in body): actionOnLeaveHitCalculator(body.status)

func _on_emotion_timer_timeout():
	#restores excitement after time runs out
	setEmotion('default')
#endregion
