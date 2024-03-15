extends CharacterBody2D

#region Public Variable
var status = {'Aggressiveness' : 1}
#endregion

#region Privated Variables
@onready var _screensize = get_viewport_rect().size
@onready var _animatedSprite = $AnimatedSprite2D
@onready var _hitbox = $Hitbox
@onready var _hitbox_collision_shape_2d = $Hitbox/CollisionShape2D
@onready var hitbox_timer = $HitboxTimer
const _SPEED = 10
const _SPEEDHIDDING = 25
var _direction = -1
var _multiplicator = 1
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _hidding = false
#endregion

func _physics_process(delta):
	_apply_gravity(delta)
	_move()
	move_and_slide()
	
func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += _gravity * delta

func _move():
	if abs(velocity.x) == 0:
		if !_hidding: 
			velocity.x = _SPEED * _direction * _multiplicator
		else: #Move faster if it's hidding
			velocity.x = _SPEEDHIDDING * _direction * _multiplicator
		
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
		velocity.x = _SPEEDHIDDING * _direction * _multiplicator

func _on_hitbox_body_entered(body):
	#Get hits only from above
	if !body.is_on_floor():
		hitbox_timer.start()
		_hitbox_collision_shape_2d.set_deferred("disabled", true)
		getHit()
	
func _on_hitbox_timer_timeout():
	_hitbox_collision_shape_2d.set_deferred("disabled", false)

func _on_visible_on_screen_notifier_2d_screen_exited():
	if (_direction == 1): scale.x = -1
	_direction = -1
	_multiplicator *= 1.25
	velocity.x = 0
	position.x += _screensize.x + 50
