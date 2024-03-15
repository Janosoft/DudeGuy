extends CharacterBody2D

#region Public Variables
signal enemyHits
var status = {'Aggressiveness' : 1}
var direction: Vector2 = Vector2(0,0)
#endregion

#region Privated Variables
@onready var _animated_sprite_2d = $AnimatedSprite2D
@onready var _hitbox_collision_shape_2d = $Hitbox/CollisionShape2D
@onready var _hitbox_timer = $Hitbox/HitboxTimer
@onready var _hitzone_collision_shape_2d = $Hitzone/CollisionShape2D
@onready var _hitzone_timer = $Hitzone/HitzoneTimer
var _lastDirection = -1
var _isHitting = false
const _SPEED = 5
const _MAXSPEED = 15
#endregion

func _physics_process(delta):
	_move()
	move_and_slide()

func getHit(fromPosition):
	if (fromPosition>0): position.x -= 10
	else: position.x += 10

func _move():
	if (_isHitting):
		velocity = Vector2(0,0)
	else:
		if (_lastDirection != sign(direction.x)):
			_lastDirection = sign(direction.x)
			scale.x=-2
		if (direction.x>0):
			velocity.x = min(velocity.x + _SPEED, _MAXSPEED)
		elif (direction.x<0):
			velocity.x = max(velocity.x - _SPEED, -_MAXSPEED)
		if (direction.y>0):
			velocity.y = min(velocity.y + _SPEED, _MAXSPEED)
		elif (direction.y<0):
			velocity.y = max(velocity.y - _SPEED, -_MAXSPEED)
		#Animate
		if (!velocity.is_zero_approx()):
			_animated_sprite_2d.play("walk")

func _hit():
	_animated_sprite_2d.play("hit_" + str(randi() % 2 + 1))
	_hitbox_timer.start()

func _on_hitbox_body_entered(body):
	emit_signal("enemyHits", body)
	_hitbox_collision_shape_2d.set_deferred("disabled", true)

func _on_hitbox_timer_timeout():
	_hitbox_collision_shape_2d.disabled= false

func _on_hitzone_body_entered(body):
	_isHitting = true
	_hit()
	_hitzone_collision_shape_2d.set_deferred("disabled", true)
	_hitzone_timer.wait_time = randf_range(2.0, 4.0)
	_hitzone_timer.start()

func _on_hitzone_timer_timeout():
	_isHitting = false
	_hitzone_collision_shape_2d.disabled= false
