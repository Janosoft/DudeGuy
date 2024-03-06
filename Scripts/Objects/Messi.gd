extends CharacterBody2D

signal got_ball
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ball = $Hitbox/CollisionShape2D
@onready var hitbox = $Hitbox
@onready var hitbox_timer = $HitboxTimer

#region Status
var status = {'WithBall' : 1}
#endregion

func hit():
	status['WithBall'] = 0
	animated_sprite_2d.play("Noball")
	hitbox_timer.start()

func gotBall():
	status['WithBall'] = 1
	animated_sprite_2d.play("default")
	emit_signal("got_ball")

func _on_hitbox_body_entered(body):
	if (body.name == 'Ball'):
		gotBall()

func _on_hitbox_timer_timeout():
	hitbox.monitoring = true
