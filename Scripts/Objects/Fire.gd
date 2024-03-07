extends CharacterBody2D

#region Public Variables
var status = {'Temperature' : 1}
#endregion

#region Privated Variables
const _SPEED = -450.0
#endregion

func _physics_process(delta):
	velocity.x = _SPEED * delta
	move_and_slide()
