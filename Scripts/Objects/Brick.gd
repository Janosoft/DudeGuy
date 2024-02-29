extends StaticBody2D

signal boringAchievement
@onready var animatedSprite = $AnimatedSprite2D
#region Status
var status = {'Striking': 3}
#endregion
var timesHit = 0

func hit():
	timesHit += 1
	animatedSprite.play()
	if (timesHit > 3):
		emit_signal("boringAchievement")
		timesHit = 0

func _on_hit_box_body_entered(body):
	if (body.name == 'DudeGuy'): hit()
