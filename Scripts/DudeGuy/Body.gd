extends Sprite2D

#region Privated Variables
@onready var _head = $Head
@onready var _animated_sprite_2d = $AnimatedSprite2D
var _temperature : int = 0
#endregion

func hideBody():
	#Used to show only the head
	_animated_sprite_2d.visible = false;

func talk(words: String) -> void:
	_head.talk(words)

func setEmotion(newEmotion: String):
	_head.setEmotion(newEmotion)

func setTemperature(newTemperature: int):
	_temperature= newTemperature
	_head.setTemperature(_temperature)
