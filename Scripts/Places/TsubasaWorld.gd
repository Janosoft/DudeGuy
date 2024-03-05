extends Node2D

@onready var dude_guy = $DudeGuy
@onready var messi = $Messi
@onready var label = $Label
@onready var label_timer = $LabelTimer

#region PlayerSettings
const SPEED = 10
const MAXSPEED = 125
var direction = 1
var currentSpeed = 1
#endregion

func _physics_process(delta):
	_controls()
	messi.move_and_slide()

func _ready():
	dude_guy.setEmotion('Love')
	dude_guy.talk('Messi goes with the ball!!')
	
func _controls():
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		messi.velocity.x =  max(messi.velocity.x - SPEED, -MAXSPEED) * currentSpeed if direction<0 else min(messi.velocity.x + SPEED, MAXSPEED) * currentSpeed
	else:
		messi.velocity.x = lerp(messi.velocity.x,0.0,0.2)

func _on_dude_guy_talking_signal(text):
	label.text = text
	label_timer.wait_time = len(text) * 0.17
	label_timer.start()

func _on_label_timer_timeout():
	label.text = ''
