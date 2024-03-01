extends CharacterBody2D
@onready var label = $Label
@onready var timer = $Timer

func setText(newText:String, time: int):
	label.text = newText
	timer.wait_time = time;
	visible = true
	timer.start()



func _on_timer_timeout():
	visible= false;
