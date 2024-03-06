extends Node2D

signal gameOver

@onready var dude_guy = $DudeGuy
@onready var messi = $Messi
@onready var ronaldo = $Ronaldo
@onready var ball = $Ball
@onready var label = $UI/Label
@onready var label_timer = $UI/LabelTimer
@onready var game_label = $UI/GameLabel
@onready var game_timer = $UI/GameTimer


#region PlayerSettings
const SPEED = 10
const MAXSPEED = 125
var direction = 1
var currentSpeed = 1
#endregion

func _process(delta):
	var time = game_timer.time_left
	game_label.text = "%02d" % fmod(time,60)

func _physics_process(delta):
	_controls()
	messi.move_and_slide()
	ronaldo.move_and_slide()
	if (ball.visible): ball.move_and_slide()

func _ready():
	await get_tree().create_timer(1).timeout
	dude_guy.setEmotion('Love')
	dude_guy.talk('Messi goes with the ball!!')
	
func _controls():
#region Messi Controls
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		messi.velocity.x =  max(messi.velocity.x - SPEED, -MAXSPEED) * currentSpeed if direction<0 else min(messi.velocity.x + SPEED, MAXSPEED) * currentSpeed
	else:
		messi.velocity.x = lerp(messi.velocity.x,0.0,0.2)
#endregion
#region Ronaldo Controls
	if (ronaldo.isTackling):
		ronaldo.velocity.x = lerp(ronaldo.velocity.x,0.0,0.01)
	else:
		if ((messi.position.x - ronaldo.position.x)>0):
			ronaldo.velocity.x = min(ronaldo.velocity.x + ronaldo.SPEED, ronaldo.MAXSPEED)
		else:
			ronaldo.velocity.x = max(ronaldo.velocity.x - ronaldo.SPEED, -ronaldo.MAXSPEED)
#endregion
#region Ball Controls
	if (ball.visible):
		ball.velocity.x = min(ball.velocity.x + ball.SPEED, ball.MAXSPEED)
#endregion

func _on_dude_guy_talking_signal(text):
	label.text = text
	label_timer.wait_time = len(text) * 0.17
	label_timer.start()

func _on_label_timer_timeout():
	label.text = ''

func _on_ronaldo_tackling_player():
	dude_guy.setEmotion('Scared')
	dude_guy.talk('Ronaldo tries to tackle Messi')

func _on_ronaldo_misses_player():
	dude_guy.setEmotion('Happy')
	dude_guy.talk('but Messi manages to escape')

func _on_game_timer_timeout():
	print_debug('Game Over')
	set_process(false)
	set_physics_process(false)
	emit_signal("gameOver")

func _on_ronaldo_hit():
	messi.hit()
	ball.position.x = messi.ball.position.x + messi.position.x
	ball.visible= true
	dude_guy.setEmotion('Sad')
	dude_guy.talk('Messi lost the ball')

func _on_messi_got_ball():
	ball.visible= false
	dude_guy.setEmotion('Love')
	dude_guy.talk('Messi recovered the ball')
