extends CharacterBody2D

#region Public Variables
var status = {'Aggressiveness' : 0}
#endregion

#region Privated Variables
@onready var _animatedSprite = $AnimatedSprite2D
const _SPEED = 250
var _direction = -1
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _dying = false
#endregion

func _physics_process(delta):
	_apply_gravity(delta)
	_move(delta)
	move_and_slide()
	
func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += _gravity * delta

func _move(delta):
	if !_dying: #Dont move if it's dying
		velocity.x = _SPEED * delta * _direction
	if is_on_wall():
		_direction *= -1
		scale.x=-1
		velocity.x = 0 #Not to get Stuck
		position.x += 1 * _direction #Not to get Stuck

func getHit():
	_die()

func _die():
	_dying = true;
	velocity.x = 0
	_animatedSprite.play("Die")

func _on_animated_sprite_2d_animation_finished():
	if _animatedSprite.animation == "die": queue_free()

func _on_hitbox_body_entered(body):
	if !body.is_on_floor():
		getHit()
