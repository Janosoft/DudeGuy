extends Node2D

#region Privated Variables
@onready var _dude_guy = $DudeGuy
@onready var _super_mario = $SuperMario
@onready var _text_box = $CanvasLayer/TextBox
@onready var _game_label = $CanvasLayer/GameLabel
@onready var _game_timer = $CanvasLayer/GameTimer
const _SPEED = 10
const _MAXSPEED = 125
const _JUMP_VELOCITY = 430
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _direction = 1
var _lastDirection = 1
var _currentSpeed = 1
var _worldsize = 0
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
	_worldsize = $"World 1-1".get_used_rect().size.x * $"World 1-1".tile_set.tile_size.x
	_dude_guy.dialogs= _dialogs
	_dude_guy.emotions= _emotions
	_dude_guy.actionsOnHit= _actionsOnHit
	_dude_guy.actionsOnLeaveHit= _actionsOnLeaveHit

func _process(_delta):
	_game_label.text = "%02d" % fmod(_game_timer.time_left,60)

func _physics_process(delta):
	_apply_gravity(delta)
	_controls()
	_dude_guy.move_and_slide()

func _apply_gravity(delta):
	if not _dude_guy.is_on_floor():
		_dude_guy.velocity.y += _gravity * delta

func _controls():
	if _dude_guy.is_on_floor():
		if Input.is_action_just_pressed("move_up"):
			_dude_guy.velocity.y = - _JUMP_VELOCITY
			_super_mario.velocity.y = - _JUMP_VELOCITY
	
	_direction = Input.get_axis("move_left", "move_right")
	if _direction:
		if _lastDirection != _direction:
			_lastDirection = _direction
			_dude_guy.scale.x=-1
			_super_mario.scale.x=-2
		_dude_guy.velocity.x =  max(_dude_guy.velocity.x - _SPEED, -_MAXSPEED) * _currentSpeed if _direction<0 else min(_dude_guy.velocity.x + _SPEED, _MAXSPEED) * _currentSpeed
		_super_mario.velocity.x =  _dude_guy.velocity.x
		#Limits the movements inside the level
		_dude_guy.position.x = clamp(_dude_guy.position.x, 17, _worldsize)
		_super_mario.position.x = _dude_guy.position.x
	elif (abs(_dude_guy.velocity.x)>0):
		_dude_guy.velocity.x = 0 
		_super_mario.velocity.x = _dude_guy.velocity.x 

func _gameOver():
	print_debug('Change World')
	set_process(false)
	set_physics_process(false)
	_super_mario.set_physics_process(false)
	get_tree().change_scene_to_file("res://Scenes/Places/TsubasaWorld.tscn")

func _on_brick_boring_achievement():
	_dude_guy.setEmotion("Sad")
	_dude_guy.talk("that was frustrating")

func _on_dude_guy_talking_signal(text):
	_text_box.setText(text)

func _on_game_timer_timeout():
	_gameOver()

func _on_castle_enter_castle():
	_gameOver()
