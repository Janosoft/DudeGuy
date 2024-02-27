extends Sprite2D

@onready var _head = $Head

func talk(words: String) -> void:
	_head.talk(words)

func emotion(newEmotion: String):
	_head.emotion(newEmotion)

func setTemperature(temperature: int):
	_head.setTemperature(temperature)
