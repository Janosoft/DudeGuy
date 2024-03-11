extends Node2D

#region Public Variables
signal gameOver
#endregion

#region Privated Variables
@onready var _dude_guy = $DudeGuy
@onready var _screensize = get_viewport_rect().size
const _SPEED = 10
const _MAXSPEED = 125
const _JUMP_VELOCITY = 350.0
var _direction = 1
var _lastDirection = 1
var _currentSpeed = 1
var _dialogs : Dictionary = {
	"Striking": {
		1: ["Whoa, check that out, that's weird", "Wow, look over there, that's odd", "Take a look at that, it's pretty strange", "Oh my, what's that? That's unusual", "What's that? That's rather peculiar"]},
	"Aggressiveness":{
		0: ["Aww, that's so sweet!", "How adorable!", "Oh, that's just too cute","Look at that, it's heartwarming", "That's so precious!"],
		1: ["Oh no, that's terrifying!", "Yikes, I'm scared!", "That's giving me the creeps","I'm getting goosebumps", "Oh wow, that's really freaking me out!"]},
	}
var _emotions : Dictionary = {
	"Striking": {
		1: ["Wonder"]},
	"Aggressiveness":{
		0: ["Happy"],
		1: ["Scared"]}
	}
var _actionsOnHit : Dictionary = {
	"Aggressiveness":{
		1: ["setEmotion","Pain"]}
	}
var _actionsOnLeaveHit : Dictionary = {}
#endregion

func _ready():
	_dude_guy.dialogs= _dialogs
	_dude_guy.emotions= _emotions
	_dude_guy.actionsOnHit= _actionsOnHit
	_dude_guy.actionsOnLeaveHit= _actionsOnLeaveHit
	
func _physics_process(delta):
	_controls()
	_dude_guy.move_and_slide()

func _controls():
	_direction = Input.get_vector("move_left","move_right","move_up","move_down")
	if (_direction.x):
		if (_lastDirection != _direction.x):
			_lastDirection = _direction.x
			_dude_guy.scale.x=-1
		_dude_guy.velocity.x =  max(_dude_guy.velocity.x - _SPEED, -_MAXSPEED) * _currentSpeed if _direction.x<0 else min(_dude_guy.velocity.x + _SPEED, _MAXSPEED) * _currentSpeed
	else:
		_dude_guy.velocity.x = lerp(_dude_guy.velocity.x,0.0,0.2)
	if (_direction.y):
		_dude_guy.velocity.y =  max(_dude_guy.velocity.y - _SPEED, -_MAXSPEED) * _currentSpeed if _direction.y<0 else min(_dude_guy.velocity.y + _SPEED, _MAXSPEED) * _currentSpeed
	else:
		_dude_guy.velocity.y = lerp(_dude_guy.velocity.y,0.0,0.2)
