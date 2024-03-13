extends CharacterBody2D

#region Public Variables
signal enemyHit
#endregion

#region Privated Variables
@onready var _animated_sprite_2d = $AnimatedSprite2D
@onready var _hitbox_collision_shape_2d = $HitBox/CollisionShape2D
@onready var _hitbox_timer = $HitBox/HitboxTimer
#endregion


func walk():
	_animated_sprite_2d.play("walk")

func stand():
	_animated_sprite_2d.play("default")

func hit():
	_animated_sprite_2d.play("hit_" + str(randi() % 2 + 1))
	_hitbox_collision_shape_2d.set_deferred("disabled", false)
	_hitbox_timer.start()

func _on_hit_box_body_entered(body):
	emit_signal("enemyHit", body)
	_hitbox_collision_shape_2d.set_deferred("disabled", true)

func _on_hitbox_timer_timeout():
	_hitbox_collision_shape_2d.set_deferred("disabled", true)
