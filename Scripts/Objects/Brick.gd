extends StaticBody2D

#region Public Variables
signal boringAchievement #warns that he was hit many times
var status = {'Striking': 1}
#endregion

#region Privated Variables
@onready var _animatedSprite = $AnimatedSprite2D
var _timesHit = 0
#endregion

func hit():
	#count the number of hits received and unlock an achievement
	_timesHit += 1
	_animatedSprite.play()
	if (_timesHit > 3):
		emit_signal("boringAchievement")
		_timesHit = 0

func _on_hit_box_body_entered(body):
	#only react with DudeGuy
	if (body.name == 'DudeGuy'): hit()
