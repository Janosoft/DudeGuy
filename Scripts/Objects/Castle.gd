extends StaticBody2D

#region Public Variables
signal enterCastle #warns that the character entered the castle
var status = {'Striking': 1}
#endregion

func _on_hitbox_body_entered(body):
	#only react with DudeGuy
	if (body.name == 'DudeGuy'):
		emit_signal("enterCastle")
