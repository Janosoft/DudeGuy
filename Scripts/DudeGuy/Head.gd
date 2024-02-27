extends Sprite2D

@onready var animationPlayer= $AnimationPlayer
@onready var eyebrows = $Eyebrows
@onready var eyes = $Eyes
@onready var mouth = $Mouth

var emotionTemp = {'Angry': 'Hot', "Scared": 'Halfcold', "Amazed": 'blushed'}
var actualTemperature = 'default'

func _ready():
	animationPlayer.current_animation = actualTemperature

func talk(words: String) -> void:
	mouth.articulate(words)

func emotion(newEmotion: String):
	if newEmotion in emotionTemp:
		if animationPlayer.has_animation(emotionTemp[newEmotion]):
			actualTemperature = emotionTemp[newEmotion]
			animationPlayer.queue(actualTemperature)
		else:
			print_debug("ERROR: the animation doesnt exist " + emotionTemp[newEmotion])
			actualTemperature = 'default'
	else:
		actualTemperature = 'default'
	
	eyebrows.emotion(newEmotion)
	eyes.emotion(newEmotion)
	mouth.emotion(newEmotion)

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
	if animationPlayer.has_animation(temperatureAnimation):
		actualTemperature = temperatureAnimation
		animationPlayer.queue(temperatureAnimation)
	else:
		print_debug("ERROR: the animation doesnt exist " + temperatureAnimation)
		actualTemperature = 'default'
