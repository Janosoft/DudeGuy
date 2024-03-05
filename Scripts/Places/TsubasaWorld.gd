extends Node2D

@onready var dude_guy = $DudeGuy
@onready var label = $Label

func _physics_process(delta):
	_controls()
	dude_guy.move_and_slide()
	
func _controls():
	pass

func _on_dude_guy_talking_signal():
	pass
