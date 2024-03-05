extends CharacterBody2D

signal tacklingPlayer
signal missesPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D
var isTackling = false

#region PlayerSettings
const SPEED = 5
const MAXSPEED = 15
#endregion

func _on_hitbox_body_entered(body):
	isTackling = true
	animated_sprite_2d.play("Tackle")
	emit_signal('tacklingPlayer')

func _on_hitbox_body_exited(body):
	isTackling = false
	animated_sprite_2d.play("default")
	emit_signal('missesPlayer')
