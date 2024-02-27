extends Sprite2D

@onready var _animationPlayer= $AnimationPlayer
@onready var _eyebrows = $Eyebrows
@onready var _eyes = $Eyes
@onready var _mouth = $Mouth

var _emotionTemp = {'Angry': 'Hot', "Scared": 'Halfcold', "Amazed": 'blushed'}
var _actualTemperature = 'default'

func _ready():
	_animationPlayer.current_animation = _actualTemperature

func talk(words: String) -> void:
	_mouth.articulate(words)

func emotion(newEmotion: String):
	if newEmotion in _emotionTemp:
		if _animationPlayer.has_animation(_emotionTemp[newEmotion]):
			_actualTemperature = _emotionTemp[newEmotion]
			_animationPlayer.queue(_actualTemperature)
		else:
			print_debug("ERROR: the animation doesnt exist " + newEmotion)
			_actualTemperature = 'default'
	else:
		_actualTemperature = 'default'
	
	_eyebrows.emotion(newEmotion)
	_eyes.emotion(newEmotion)
	_mouth.emotion(newEmotion)

func setTemperature(temperature: int):
	var temperatureAnimation: String
	#TODO OPTIMIZE
	if temperature<-2:
		temperatureAnimation = 'Cold'
	elif temperature>=-2 and temperature <0:
		temperatureAnimation = 'HalfCold'
	elif temperature>0:
		temperatureAnimation = 'Hot'
	else:
		temperatureAnimation = 'default'
	if _animationPlayer.has_animation(temperatureAnimation):
		_actualTemperature = temperatureAnimation
		_animationPlayer.queue(_actualTemperature)
	else:
		print_debug("ERROR: the animation doesnt exist " + temperatureAnimation)
		_actualTemperature = 'default'
