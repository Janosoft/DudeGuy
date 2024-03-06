extends Node2D

@onready var dude_guy = $DudeGuy
@onready var text_box = $CanvasLayer/TextBox

#region PlayerSettings
const SPEED = 10
const MAXSPEED = 125
const JUMP_VELOCITY = 350.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1
var lastDirection = 1
var currentSpeed = 1
#endregion

var dialogs : Dictionary = {
	"Striking": {
		1: ["Whoa, check that out, that's weird", "Wow, look over there, that's odd", "Take a look at that, it's pretty strange", "Oh my, what's that? That's unusual", "What's that? That's rather peculiar"]},
	"Aggressiveness":{
		0: ["Aww, that's so sweet!", "How adorable!", "Oh, that's just too cute","Look at that, it's heartwarming", "That's so precious!"],
		1: ["Oh no, that's terrifying!", "Yikes, I'm scared!", "That's giving me the creeps","I'm getting goosebumps", "Oh wow, that's really freaking me out!"]},
	}

func _physics_process(delta):
	_apply_gravity(delta)
	_controls()
	dude_guy.move_and_slide()
	text_box.move_and_slide()

func _apply_gravity(delta):
	if not dude_guy.is_on_floor():
		dude_guy.velocity.y += gravity * delta

func _controls():
	if dude_guy.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			dude_guy.velocity.y = - JUMP_VELOCITY
	direction = Input.get_axis("move_left", "move_right")	
	if direction:
		if lastDirection != direction:
			lastDirection = direction
			dude_guy.scale.x=-1
		dude_guy.velocity.x =  max(dude_guy.velocity.x - SPEED, -MAXSPEED) * currentSpeed if direction<0 else min(dude_guy.velocity.x + SPEED, MAXSPEED) * currentSpeed
	else:
		dude_guy.velocity.x = lerp(dude_guy.velocity.x,0.0,0.2)
	
func _on_brick_boring_achievement():
	dude_guy.setEmotion("Sad")
	dude_guy.talk("that was frustrating")

func _on_dude_guy_talking_signal(text):
	text_box.setText(text)
