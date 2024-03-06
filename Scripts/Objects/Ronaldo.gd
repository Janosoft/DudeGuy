extends CharacterBody2D

signal tacklingPlayer
signal missesPlayer
signal hit
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hit_timer = $HitTimer
var isTackling = false

#region PlayerSettings
const SPEED = 5
const MAXSPEED = 15
#endregion

func _on_hitbox_body_entered(body):
	#print_debug(body.name + ' entered')
	isTackling = true
	animated_sprite_2d.play("Tackle")
	emit_signal('tacklingPlayer')
	if (hit_timer.is_stopped()):
		#print_debug('tacklingPlayer start')
		hit_timer.start()

func _on_hitbox_body_exited(body):
	#print_debug(body.name + ' exited')
	isTackling = false
	animated_sprite_2d.play("default")
	emit_signal('missesPlayer')
	if (!hit_timer.is_stopped()):
		#print_debug('tacklingPlayer stop')
		hit_timer.stop()

func _on_hit_timer_timeout():
	#print_debug('Ronaldo hit')
	emit_signal("hit")
