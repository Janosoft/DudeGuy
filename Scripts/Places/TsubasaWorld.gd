extends Node2D

#region Public Variables
signal gameOver
#endregion

#region Privated Variables
@onready var _dude_guy = $DudeGuy
@onready var _messi = $Messi
@onready var _ronaldo = $Ronaldo
@onready var _ball = $Ball
@onready var _label = $UI/Label
@onready var _label_timer = $UI/LabelTimer
@onready var _game_label = $UI/GameLabel
@onready var _game_timer = $UI/GameTimer
var _dialogs : Dictionary = {
	"WithBall": {
		0: ["Messi loses the ball", "Messi no longer has the ball"],
		1: ["Messi goes with the ball", "Messi runs with the ball"]},
	"isTackling":{
		0: ["Ronaldo runs to try to catch him", "Ronaldo is chasing him down", "Ronaldo is running fast in an attempt to catch him"],
		1: ["Ronaldo presses forward to steal the ball", "Ronaldo makes a move to intercept the ball"]},
	"isRolling":{
		1: ["The ball is rolling forward.", "The ball is gliding across the field"]}
	}
var _emotions : Dictionary = {
	"WithBall": {
		0: ["Sad"],
		1: ["Love"]},
	"isTackling":{
		0: ["Wonder"],
		1: ["Angry"]},
	"isRolling":{
		1: ["default"]}
	}
#endregion

func _ready():
	_dude_guy.dialogs= _dialogs
	_dude_guy.emotions= _emotions

func _process(delta):
	var time = _game_timer.time_left
	_game_label.text = "%02d" % fmod(time,60)

func _physics_process(delta):
	_controls()
	if (_ball.visible): _ball.move_and_slide()
	
func _controls():
	_messi.direction = Input.get_axis("move_left", "move_right")
	_ronaldo.direction = 1 if (_messi.position.x - _ronaldo.position.x)>0 else 0

func _gameOver():
	print_debug('Game Over')
	set_process(false)
	set_physics_process(false)
	emit_signal("gameOver")

func _on_dude_guy_talking_signal(text):
	_label.text = text
	_label_timer.wait_time = len(text) * 0.17
	_label_timer.start()

func _on_label_timer_timeout():
	_label.text = ''

func _on_game_timer_timeout():
	_gameOver()

func _on_ronaldo_hit():
	#print_debug("hit balls")
	_messi.hit()
	_ball.position.x = _messi.ball.position.x + _messi.position.x
	_ball.visible= true

func _on_messi_got_ball():
	#print_debug("recovers balls")
	_ball.visible= false
