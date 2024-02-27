extends Node2D

@onready var dude_guy = $DudeGuy

func _ready():
	dude_guy.talk("Hello Moto")
