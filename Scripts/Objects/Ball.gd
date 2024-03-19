extends CharacterBody2D

#region Public Variables
var status = {'isRolling' : 1}
#endregion

#region Privated Variables
@onready var _screensize = get_viewport_rect().size
const _SPEED = 10
const _MAXSPEED = 20
#endregion

func _physics_process(delta):
	_move(delta)
	move_and_slide()

func _move(_delta):
	if (visible):
		velocity.x = min(velocity.x + _SPEED, _MAXSPEED)
		position.x = clamp(position.x,16,_screensize.x - 16) #Limit movements within the screen
