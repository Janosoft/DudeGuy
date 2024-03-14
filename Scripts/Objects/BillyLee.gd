extends CharacterBody2D

#region Public Variables
signal enemyHit
#endregion

#region Privated Variables
@onready var _animated_sprite_2d = $AnimatedSprite2D
@onready var _hitbox_collision_shape_2d = $HitBox/CollisionShape2D
@onready var _hitbox_timer = $HitBox/HitboxTimer
var _isHitting = false
#endregion

func walk():
	if (!_isHitting and _animated_sprite_2d.animation!= "walk"):
		_animated_sprite_2d.play("walk")

func stand():
	if (!_isHitting and _animated_sprite_2d.animation!= "default"):
		_animated_sprite_2d.play("default")

func hit():
	_isHitting = true
	_animated_sprite_2d.play("hit_" + str(randi() % 2 + 1))
	_hitbox_collision_shape_2d.set_deferred("disabled", false)
	_hitbox_timer.start()

func _on_hit_box_body_entered(body):
	emit_signal("enemyHit", body)
	_hitbox_collision_shape_2d.set_deferred("disabled", true)

func _on_hitbox_timer_timeout():
	_isHitting= false
	_hitbox_collision_shape_2d.set_deferred("disabled", true)
