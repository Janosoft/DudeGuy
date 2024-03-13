extends CharacterBody2D

#region Public Variables
signal enemyHit
#endregion

#region Privated Variables
@onready var _animated_sprite_2d = $AnimatedSprite2D
@onready var _hitbox_collision_shape_2d = $Hitbox/CollisionShape2D
@onready var _hitbox_timer = $Hitbox/HitboxTimer

var _direction = -1
const _SPEED = 500
#endregion

func _physics_process(delta):
	_move(delta)
	move_and_slide()

func getHit(fromPosition):
	if (fromPosition>0): position.x -= 10
	else: position.x += 10

func _move(delta):
	pass

func _hit():
	_animated_sprite_2d.play("hit_" + str(randi() % 2 + 1))
	_hitbox_collision_shape_2d.set_deferred("disabled", false)
	_hitbox_timer.start()

func _on_hitbox_body_entered(body):
	emit_signal("enemyHit", body)
	_hitbox_collision_shape_2d.set_deferred("disabled", true)

func _on_hitbox_timer_timeout():
	_hitbox_collision_shape_2d.disabled= true
	_hitbox_collision_shape_2d.set_deferred("disabled", true)
