extends Sprite2D

@onready var _body = $Body

#region Status
var _perception : int = 0
var _temperature : int = 0
#endregion

var _actualEmotion: String = 'default'

func _ready():
	emotion(_actualEmotion)
	
func talk(words: String):
	_body.talk(words)

func emotion(newEmotion: String):
	_body.emotion(newEmotion)

func setTemperature(newTemperature: int):
	_temperature= newTemperature
	_body.setTemperature(_temperature)

func setPerception(newPerception: int):
	_perception= newPerception
