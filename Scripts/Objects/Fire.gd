extends CharacterBody2D

#region Status
var temperature : int = 5
var aggressiveness : int = 0
#endregion

const SPEED = -450.0

func _physics_process(delta):
	velocity.x = SPEED * delta
	move_and_slide()
