extends Sprite2D

#region Privated Variables
@onready var _animationPlayer= $AnimationPlayer
var _dudeNode : Node2D
var _actualEmotion = 'default'
#VISION:
@onready var _rayCast = $RayCast2D
var _rayCastOperatorX = 25
var _rayCastOperatorY = -15
const _rayCastSize = 150
var _lastObjectSeen: Object = null
#endregion

func _ready():
	_animationPlayer.current_animation = "default"
	#obtains the Dudeguy node so that it can then report what has been seen:
	var rootNode = get_tree().get_root().get_child(0)
	_dudeNode = rootNode.find_child("DudeGuy")

func _physics_process(_delta):
	if (_rayCast.enabled):
		_aim()
		_checkObjectCollision()

func setEmotion(newEmotion: String):
	if _animationPlayer.has_animation(newEmotion):
		_actualEmotion = newEmotion
		_animationPlayer.queue(_actualEmotion)
	else:
		print_debug("ERROR: the animation doesnt exist " + newEmotion)
		_actualEmotion = 'default'

func _aim():
	#move your eyes up and down
	if (_rayCast.target_position.x > _rayCastSize): _rayCastOperatorX *= -1
	elif (_rayCast.target_position.x < 0): _rayCastOperatorX *= -1
	if (_rayCast.target_position.y > _rayCastSize): _rayCastOperatorY *= -1
	elif (_rayCast.target_position.y < -_rayCastSize): _rayCastOperatorY *= -1
	
	_rayCast.target_position.x+= _rayCastOperatorX
	_rayCast.target_position.y+= _rayCastOperatorY

func _checkObjectCollision():
	#reports what was seen and pauses the vision so you are not reacting all the time
	if (_rayCast.is_colliding() and _lastObjectSeen != _rayCast.get_collider() and _rayCast.get_collider().visible):
		_rayCast.enabled = false
		_lastObjectSeen = _rayCast.get_collider()
		_dudeNode.checkObject(_rayCast.get_collider())
		$RayCastTimer.start()

func _on_ray_cast_timer_timeout():
	#reactivates vision
	_rayCast.enabled = true

func _on_wink_timer_timeout():
	#blinks every so often
	$BlinkTimer.wait_time = randi() % (10 - 7 + 1) + 7 #Random between 7 - 10 secs
	_animationPlayer.queue("Blink")
	_animationPlayer.queue(_actualEmotion) #Restores actual emotion
