extends Node2D

#region Public Variables
signal gameOver
#endregion

#region Privated Variables
@onready var _dude_guy = $DudeGuy
@onready var _text_box = $CanvasLayer/TextBox
const _SPEED = 10
const _MAXSPEED = 125
const _JUMP_VELOCITY = 350.0
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
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
#endregion

func _ready():
	_dude_guy.dialogs= _dialogs
	_dude_guy.emotions= _emotions

func _physics_process(delta):
	_apply_gravity(delta)
	_controls()
	_dude_guy.move_and_slide()

func _apply_gravity(delta):
	if not _dude_guy.is_on_floor():
		_dude_guy.velocity.y += _gravity * delta

func _controls():
	if _dude_guy.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			_dude_guy.velocity.y = - _JUMP_VELOCITY
	_direction = Input.get_axis("move_left", "move_right")	
	if _direction:
		if _lastDirection != _direction:
			_lastDirection = _direction
			_dude_guy.scale.x=-1
		_dude_guy.velocity.x =  max(_dude_guy.velocity.x - _SPEED, -_MAXSPEED) * _currentSpeed if _direction<0 else min(_dude_guy.velocity.x + _SPEED, _MAXSPEED) * _currentSpeed
	else:
		_dude_guy.velocity.x = lerp(_dude_guy.velocity.x,0.0,0.2)
	
func _on_brick_boring_achievement():
	_dude_guy.setEmotion("Sad")
	_dude_guy.talk("that was frustrating")

func _on_dude_guy_talking_signal(text):
	_text_box.setText(text)
