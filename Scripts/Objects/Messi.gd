extends CharacterBody2D

#region Public Variables
signal got_ball
@onready var ball = $Hitbox/CollisionShape2D #used to get actual ball position
var status = {'WithBall' : 1}
var direction = 1
#endregion

#region Privated Variables
@onready var _animated_sprite_2d = $AnimatedSprite2D
@onready var _hitbox = $Hitbox
@onready var _hitbox_timer = $HitboxTimer
@onready var _screensize = get_viewport_rect().size
const _SPEED = 10
const _MAXSPEED = 125
var _currentSpeed = 1
#endregion

func _physics_process(delta):
	_move(delta)
	move_and_slide()

func _move(_delta):
	if direction:
		velocity.x =  max(velocity.x - _SPEED, -_MAXSPEED) * _currentSpeed if direction<0 else min(velocity.x + _SPEED, _MAXSPEED) * _currentSpeed
		position.x = clamp(position.x,32,_screensize.x - 32) #Limit movements within the screen
	else:
		velocity.x = lerp(velocity.x,0.0,0.2)
		position.x = clamp(position.x,32,_screensize.x - 32) #Limit movements within the screen

func hit():
	status['WithBall'] = 0
	_animated_sprite_2d.play("Noball")
	_hitbox.monitoring = false
	_hitbox_timer.start()

func gotBall():
	status['WithBall'] = 1
	_animated_sprite_2d.play("default")
	emit_signal("got_ball")

func _on_hitbox_body_entered(body):
	if (body.name == 'Ball'):
		gotBall()

func _on_hitbox_timer_timeout():
	_hitbox.monitoring = true
