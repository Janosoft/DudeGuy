extends Node2D

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
	#shows the remaining time
	_game_label.text = "%02d" % fmod(_game_timer.time_left,60)

func _physics_process(_delta):
	#DudeGuy's body is hidden in Node
	_controls()
	if (_ball.visible): _ball.move_and_slide()
	
func _controls():
	_messi.direction = Input.get_axis("move_left", "move_right") #moves left and right
	_ronaldo.direction = sign( _messi.position.x - _ronaldo.position.x) #moves Ronaldo towards the player's direction

func _gameOver():
	#go to the next level
	print_debug('Change World')
	set_process(false)
	set_physics_process(false)
	get_tree().change_scene_to_file("res://Scenes/Places/DoubleDragonWorld.tscn")

func _on_dude_guy_talking_signal(text):
	#shows the text in the TextBox
	_label.text = text
	_label_timer.wait_time = len(text) * 0.17 # 0.17 is the animation speed of each letter
	_label_timer.start()

func _on_label_timer_timeout():
	_label.text = ''

func _on_game_timer_timeout():
	_gameOver()

func _on_ronaldo_hit():
	#makes Messi lose the ball
	#print_debug("hit balls")
	_messi.hit()
	_ball.position.x = _messi.ball.position.x + _messi.position.x
	_ball.visible= true

func _on_messi_got_ball():
	#makes Messi recover the ball
	#print_debug("recovers balls")
	_ball.visible= false
