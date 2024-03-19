extends CharacterBody2D

#region Privated Variables
@onready var _label = $Label
@onready var _timer = $Timer
#endregion

func setText(newText:String):
	#shows the text for a while
	_label.text = newText
	_timer.wait_time = len(newText) * 0.17 # 0.17 is the animation speed of each letter
	visible = true
	_timer.start()
	
func _on_timer_timeout():
	visible= false;
