extends CharacterBody2D

#region Privated Variables
@onready var _animatedSprite = $AnimatedSprite2D #super mario bodysuit
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#endregion

func _physics_process(delta):
	_apply_gravity(delta)
	_animate()
	move_and_slide()

func _animate():
	if abs(velocity.x) == 0: _animatedSprite.play("default")
	else: _animatedSprite.play("walk")

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += _gravity * delta
