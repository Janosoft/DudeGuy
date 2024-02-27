extends Sprite2D

@onready var _head = $Head

#region Status
var _temperature : int = 0
#endregion

func talk(words: String) -> void:
	_head.talk(words)

func emotion(newEmotion: String):
	_head.emotion(newEmotion)

func setTemperature(newTemperature: int):
	_temperature= newTemperature
	_head.setTemperature(_temperature)
