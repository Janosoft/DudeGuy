extends CharacterBody2D

#region Public Variable
var status = {'Aggressiveness' : 1}
#endregion

#region Privated Variables
@onready var _animatedSprite = $AnimatedSprite2D
@onready var _hitbox = $Hitbox
@onready var _hitbox_collision_shape_2d = $Hitbox/CollisionShape2D
@onready var hitbox_timer = $HitboxTimer
const _SPEED = 500
var _direction = -1
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _hidding = false
#endregion

func _physics_process(delta):
	_apply_gravity(delta)
	_move(delta)
	move_and_slide()
	
func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += _gravity * delta

func _move(delta):
	if !_hidding: 
		velocity.x = _SPEED * delta * _direction
	else: #Move faster if it's hidding
		velocity.x = _SPEED * delta * _direction * 10
		
	if is_on_wall():
		_direction *= -1
		scale.x=-1
		velocity.x = 0 #Not to get Stuck
		position.x += 1 * _direction #Not to get Stuck

func getHit():
	_direction *= -1
	if (!_hidding):
		_hidding = true
		_animatedSprite.play("Hide")

func _on_hitbox_body_entered(body):
	#Get hits only from above
	if !body.is_on_floor():
		hitbox_timer.start()
		_hitbox_collision_shape_2d.set_deferred("disabled", true)
		getHit()
	
func _on_hitbox_timer_timeout():
	_hitbox_collision_shape_2d.set_deferred("disabled", false)
