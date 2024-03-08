extends CharacterBody2D

#region Public Variables
signal hit
var status = {'isTackling' : 0}
var direction = 1
#endregion

#region Privated Variables
@onready var _animated_sprite_2d = $AnimatedSprite2D
@onready var _hit_timer = $HitTimer
const _SPEED = 5
const _MAXSPEED = 15
#endregion

func _physics_process(delta):
	_move(delta)
	move_and_slide()

func _move(delta):
	if (status['isTackling']):
		velocity.x = lerp(velocity.x,0.0,0.01)
	else:
		if (direction>0):
			velocity.x = min(velocity.x + _SPEED, _MAXSPEED)
		else:
			velocity.x = max(velocity.x - _SPEED, -_MAXSPEED)

func _on_hitbox_body_entered(body):
	#print_debug(body.name + ' entered')
	status['isTackling'] = 1
	_animated_sprite_2d.play("Tackle")
	if (_hit_timer.is_stopped()):
		#print_debug('tacklingPlayer start')
		_hit_timer.start()

func _on_hitbox_body_exited(body):
	#print_debug(body.name + ' exited')
	if (status['isTackling']):
		status['isTackling'] = 0
		_animated_sprite_2d.play("default")
	if (!_hit_timer.is_stopped()):
		#print_debug('tacklingPlayer stop')
		_hit_timer.stop()

func _on_hit_timer_timeout():
	#print_debug('Ronaldo hit')
	status['isTackling'] = 0
	_animated_sprite_2d.play("default")
	emit_signal("hit")
