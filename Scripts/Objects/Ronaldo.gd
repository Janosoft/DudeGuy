extends CharacterBody2D

#region Public Variables
signal hit
var status = {'isTackling' : 0}
var direction = 1
#endregion

#region Privated Variables
@onready var _animated_sprite_2d = $AnimatedSprite2D
@onready var _hit_timer = $HitTimer
const _SPEED = 50
#endregion

func _physics_process(delta):
	_move()
	move_and_slide()

func _move():
	if (status['isTackling']):
		if (velocity.x != 0):
			#print_debug("stop")
			velocity.x = 0
	elif (velocity.x == 0):
		if (direction>0):
			#print_debug("moves ->")
			velocity.x = _SPEED
		else:
			#print_debug("moves <-")
			velocity.x = -_SPEED

func _on_hitbox_body_entered(body):
	#print_debug('tacklingPlayer start')
	_hit_timer.start()
	status['isTackling'] = 1
	_animated_sprite_2d.play("Tackle")

func _on_hitbox_body_exited(body):
	#print_debug('tacklingPlayer stop')
	_hit_timer.stop()
	status['isTackling'] = 0
	_animated_sprite_2d.play("default")

func _on_hit_timer_timeout():
	#print_debug('Hit timeout')
	emit_signal("hit")
	_animated_sprite_2d.play("default")
