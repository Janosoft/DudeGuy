extends Node2D

@onready var dude_guy = $DudeGuy

#region PlayerSettings
const SPEED = 10
const MAXSPEED = 125
const JUMP_VELOCITY = 350.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0
var currentSpeed = 1
#endregion

func _physics_process(delta):
	_apply_gravity(delta)
	_controls()
	dude_guy.move_and_slide()

func _apply_gravity(delta):
	if not dude_guy.is_on_floor():
		dude_guy.velocity.y += gravity * delta

func _controls():
	if dude_guy.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			dude_guy.velocity.y = - JUMP_VELOCITY
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		dude_guy.velocity.x =  max(dude_guy.velocity.x - SPEED, -MAXSPEED) * currentSpeed if direction<0 else min(dude_guy.velocity.x + SPEED, MAXSPEED) * currentSpeed
	else:
		dude_guy.velocity.x = lerp(dude_guy.velocity.x,0.0,0.2)
		
	
func _on_brick_boring_achievement():
	dude_guy.setEmotion("Sad")
