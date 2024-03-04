extends CharacterBody2D

#region Status
var status = {'Aggressiveness' : 1}
#endregion

const _SPEED = 250
var _direction = -1
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _dying = false

@onready var _animatedSprite = $AnimatedSprite2D

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
		position.x += 1 * _direction #Not to get Stuck

func hit():
	_die()

func _die():
	_dying = true;
	velocity.x = 0
	_animatedSprite.play("die")

func _on_animated_sprite_2d_animation_finished():
	if _animatedSprite.animation == "die": queue_free()

func _on_hitbox_body_entered(body):
	hit()
