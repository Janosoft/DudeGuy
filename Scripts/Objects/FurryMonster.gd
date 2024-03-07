extends CharacterBody2D

#region Public Variables
var status = {'Aggressiveness' : 5}
#endregion

#region Privated Variables
const _SPEED = -300.0
#endregion

func _physics_process(delta):
	velocity.x = _SPEED * delta
	move_and_slide()
