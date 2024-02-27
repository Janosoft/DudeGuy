extends Sprite2D

@onready var _animationPlayer= $AnimationPlayer

var _actualEmotion = 'default'

func _ready():
	_animationPlayer.current_animation = "default"
	
func emotion(newEmotion: String):
	if _animationPlayer.has_animation(newEmotion):
		_actualEmotion = newEmotion
		_animationPlayer.queue(_actualEmotion)
	else:
		print_debug("ERROR: the animation doesnt exist " + newEmotion)
		_actualEmotion = 'default'
