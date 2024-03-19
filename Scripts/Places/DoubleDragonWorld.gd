extends Node2D

#region Privated Variables
@onready var _dude_guy = $DudeGuy
@onready var _billy_lee = $BillyLee
@onready var _abobo = $Abobo
@onready var _background = $Background
@onready var _text_box = $CanvasLayer/TextBox
@onready var _game_label = $CanvasLayer/GameLabel
@onready var _game_timer = $CanvasLayer/GameTimer
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

func _process(delta):
	#shows the remaining time
	_game_label.text = "%02d" % fmod(_game_timer.time_left,60)
	
func _physics_process(delta):
	#DudeGuy's body is hidden in Node
	_controls()
	_dude_guy.move_and_slide()
	_billy_lee.move_and_slide()

func _controls():
	#moves in all directions
	#Billy's body and DudeGuy head moves together
	_direction = Input.get_vector("move_left","move_right","move_up","move_down")
	if (_direction.x or _direction.y):
		_billy_lee.walk()
	else:
		_billy_lee.stand()
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
	
	#limits the movements inside the level
	_dude_guy.position.x = clamp(_dude_guy.position.x, 17, _background.texture.get_size().x-50)
	_dude_guy.position.y = clamp(_dude_guy.position.y, 116, _background.texture.get_size().y)
	_billy_lee.position.x = clamp(_billy_lee.position.x, 17, _background.texture.get_size().x-50)
	_billy_lee.position.y = clamp(_billy_lee.position.y, 113, _background.texture.get_size().y-3)
	
	if Input.is_action_just_pressed("fire"):
		_billy_lee.hit()
	
	#moves Abobo towards the player's direction
	_abobo.direction = Vector2(sign(_dude_guy.position.x + 17 - _abobo.position.x), sign(_dude_guy.position.y - 17 - _abobo.position.y))

func _on_billy_lee_enemy_hit(body):
	#hit something
	_timesHit = 0
	_dude_guy.setEmotion("Happy")
	_dude_guy.talk("Take that!")
	body.getHit(_billy_lee.position.x - body.position.x)

func _on_dude_guy_talking_signal(text):
	#shows the text in the TextBox
	_text_box.setText(text)

func _on_abobo_enemy_hits(body):
	#Abobo hits player
	if (body.name == "DudeGuy"):
		if (_timesHit<3):
			_timesHit += 1
			_dude_guy.setEmotion("Pain")
			_dude_guy.talk("Ouch")
		else:
			_timesHit = 0
			_dude_guy.setEmotion("Sad")
			_dude_guy.talk("It hurts!")

func _gameOver():
	#go to the next level
	print_debug('Change World')
	set_process(false)
	set_physics_process(false)
	get_tree().change_scene_to_file("res://Scenes/Places/TestEnvironment.tscn")
	
func _on_timer_timeout():
	_gameOver()
