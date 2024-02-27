extends Sprite2D

@onready var body = $Body

var actualEmotion = 'default'

func _ready():
	emotion(actualEmotion)
	
func talk(words: String):
	body.talk(words)

func emotion(newEmotion: String):
	body.emotion(newEmotion)

func setTemperature(temperature: int):
	body.setTemperature(temperature)
