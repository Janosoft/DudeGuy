extends Sprite2D

@onready var _animationPlayer= $AnimationPlayer
#region Vision
@onready var _rayCast = $RayCast2D
var _rayCastOperatorX = 10
var _rayCastOperatorY = -10
const _rayCastSize = 150
#endregion

var _dudeNode : Node2D
var _actualEmotion = 'default'

func _ready():
	_animationPlayer.current_animation = "default"
	var rootNode = get_tree().get_root().get_child(0)
	_dudeNode = rootNode.find_child("DudeGuy")

func _physics_process(delta):
	if (_rayCast.enabled):
		_aim()
		_checkObjectCollision()

func emotion(newEmotion: String):
	if _animationPlayer.has_animation(newEmotion):
		_actualEmotion = newEmotion
		_animationPlayer.queue(_actualEmotion)
	else:
		print_debug("ERROR: the animation doesnt exist " + newEmotion)
		_actualEmotion = 'default'

func _aim():
	if (_rayCast.target_position.x > _rayCastSize): _rayCastOperatorX *= -1
	elif (_rayCast.target_position.x < 0): _rayCastOperatorX *= -1
	if (_rayCast.target_position.y > _rayCastSize): _rayCastOperatorY *= -1
	elif (_rayCast.target_position.y < -_rayCastSize): _rayCastOperatorY *= -1
	
	_rayCast.target_position.x+= _rayCastOperatorX
	_rayCast.target_position.y+= _rayCastOperatorY

func _checkObjectCollision():
	if _rayCast.is_colliding():
		_rayCast.enabled = false
		print_debug(_rayCast.get_collider().name)
	#TODO how this can be reenabled
