extends Sprite2D

@onready var _body = $Body

#region Status
var perception : int = 0
#endregion

var _actualEmotion: String = 'default'

func _ready():
	emotion(_actualEmotion)
	
func talk(words: String):
	_body.talk(words)

func emotion(newEmotion: String):
	_body.emotion(newEmotion)

func setTemperature(newTemperature: int):
	_body.setTemperature(newTemperature)

func setPerception(newPerception: int):
	perception= newPerception
