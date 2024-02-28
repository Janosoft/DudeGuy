extends CharacterBody2D

#region Status
var temperature : int = 0
var aggressiveness : int = 5
#endregion

const SPEED = -300.0

func _physics_process(delta):
	velocity.x = SPEED * delta
	move_and_slide()
