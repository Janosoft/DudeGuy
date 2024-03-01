extends CharacterBody2D
@onready var label = $Label
@onready var timer = $Timer

func setText(newText:String):
	label.text = newText
	timer.wait_time = len(newText) * 0.17
	visible = true
	timer.start()
	
func _on_timer_timeout():
	visible= false;
