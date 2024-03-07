extends Sprite2D

#region Privated Variables
@onready var _animationPlayer= $AnimationPlayer
@onready var _eyebrows = $Eyebrows
@onready var _eyes = $Eyes
@onready var _mouth = $Mouth
var _temperature : int = 0
const _temperatureAnimation = { -5: 'Cold', -4: 'Cold', -3: 'Cold',
								-2: 'HalfCold', -1: 'HalfCold',
								 0: 'default',
								 1: 'Blushed', 2: 'Blushed',
								 3: 'Hot', 4: 'Hot', 5: 'Hot'}
const _emotionTemperature = {'Scared': -2, 'default': 0, 'Amazed': 2, 'Angry': 5}
#endregion

func _ready():
	_animationPlayer.current_animation = _temperatureAnimation.get(_temperature)

func talk(words: String) -> void:
	_mouth.articulate(words)

func setEmotion(newEmotion: String):
	if newEmotion in _emotionTemperature:
		_temperature = _emotionTemperature[newEmotion]
	else:
		_temperature = 0
	setTemperature(_temperature)
	_eyebrows.setEmotion(newEmotion)
	_eyes.setEmotion(newEmotion)
	_mouth.setEmotion(newEmotion)

func setTemperature(newTemperature: int):
	_temperature= newTemperature
	if _animationPlayer.has_animation(_temperatureAnimation.get(_temperature)):
		_animationPlayer.queue(_temperatureAnimation.get(_temperature))
	else:
		print_debug("ERROR: the animation temperature doesnt exist " + str(newTemperature))
		_temperature = 0
