extends Node2D

#region Public Variables
signal gameOver
#endregion

#region Privated Variables
@onready var _dude_guy = $DudeGuy
@onready var _billy_lee = $BillyLee
@onready var _abobo = $Abobo
@onready var _background = $Background
@onready var _text_box = $CanvasLayer/TextBox
const _SPEED = 10
const _MAXSPEED = 125
const _JUMP_VELOCITY = 350.0
var _timesHit = 0
var _direction = 1
var _lastDirection = 1
var _currentSpeed = 1
var _dialogs : Dictionary = {
	"Aggressiveness":{
		1: ["Let's do this!", "Time to fight!", "Thug sighted!", "Let's the battle begin!"]}
	}
var _emotions : Dictionary = {
	"Aggressiveness":{
		1: ["Angry"]}
	}
var _actionsOnHit : Dictionary = {
	"Aggressiveness":{1: ["setEmotion","Angry"]}
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
	_billy_lee.move_and_slide()

func _controls():
	_direction = Input.get_vector("move_left","move_right","move_up","move_down")
	if (_direction.x):
		if (_lastDirection != sign(_direction.x)):
			_lastDirection = sign(_direction.x)
			_dude_guy.scale.x=-1
			_billy_lee.scale.x=-2
		_dude_guy.velocity.x =  max(_dude_guy.velocity.x - _SPEED, -_MAXSPEED) * _currentSpeed if _direction.x<0 else min(_dude_guy.velocity.x + _SPEED, _MAXSPEED) * _currentSpeed
		_billy_lee.velocity.x =  max(_billy_lee.velocity.x - _SPEED, -_MAXSPEED) * _currentSpeed if _direction.x<0 else min(_billy_lee.velocity.x + _SPEED, _MAXSPEED) * _currentSpeed
	else:
		_dude_guy.velocity.x = lerp(_dude_guy.velocity.x,0.0,0.2)
		_billy_lee.velocity.x = lerp(_billy_lee.velocity.x,0.0,0.2)
	
	if (_direction.y):
		_dude_guy.velocity.y =  max(_dude_guy.velocity.y - _SPEED, -_MAXSPEED) * _currentSpeed if _direction.y<0 else min(_dude_guy.velocity.y + _SPEED, _MAXSPEED) * _currentSpeed
		_billy_lee.velocity.y =  max(_billy_lee.velocity.y - _SPEED, -_MAXSPEED) * _currentSpeed if _direction.y<0 else min(_billy_lee.velocity.y + _SPEED, _MAXSPEED) * _currentSpeed
	else:
		_dude_guy.velocity.y = lerp(_dude_guy.velocity.y,0.0,0.2)
		_billy_lee.velocity.y = lerp(_billy_lee.velocity.y,0.0,0.2)
	
	#Limits the movements inside the level
	_dude_guy.position.x = clamp(_dude_guy.position.x, 17, _background.texture.get_size().x-50)
	_dude_guy.position.y = clamp(_dude_guy.position.y, 116, _background.texture.get_size().y)
	_billy_lee.position.x = clamp(_billy_lee.position.x, 17, _background.texture.get_size().x-50)
	_billy_lee.position.y = clamp(_billy_lee.position.y, 113, _background.texture.get_size().y-3)
	
	if Input.is_action_just_pressed("fire"):
		_billy_lee.hit()
	
	#Moves Abobo
	_abobo.direction = Vector2(sign(_dude_guy.position.x + 17 - _abobo.position.x), sign(_dude_guy.position.y - 17 - _abobo.position.y))

func _on_billy_lee_enemy_hit(body):
	_timesHit = 0
	_dude_guy.setEmotion("Happy")
	_dude_guy.talk("Take that!")
	body.getHit(_billy_lee.position.x - body.position.x)

func _on_dude_guy_talking_signal(text):
	_text_box.setText(text)

func _on_abobo_enemy_hits(body):
	if (body.name == "DudeGuy"):
		if (_timesHit<3):
			_timesHit += 1
			_dude_guy.setEmotion("Pain")
			_dude_guy.talk("Ouch")
		else:
			_timesHit = 0
			_dude_guy.setEmotion("Sad")
			_dude_guy.talk("It hurts!")
