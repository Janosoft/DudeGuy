extends Sprite2D

@onready var animationPlayer= $AnimationPlayer

var actualEmotion = 'default'

func _ready():
	animationPlayer.current_animation = "default"
	
func emotion(newEmotion: String):
	if animationPlayer.has_animation(newEmotion):
		actualEmotion = newEmotion
		animationPlayer.queue(actualEmotion)
	else:
		print_debug("ERROR: the animation doesnt exist " + newEmotion)
		actualEmotion = 'default'
