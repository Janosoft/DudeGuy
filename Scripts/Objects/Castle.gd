extends StaticBody2D

#region Public Variables
signal enterCastle
var status = {'Striking': 1}
#endregion

func _on_hitbox_body_entered(body):
	if (body.name == 'DudeGuy'):
		emit_signal("enterCastle")
