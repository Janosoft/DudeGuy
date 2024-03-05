extends Node2D

signal achievementUnlocked
@onready var dude_guy = $DudeGuy
@onready var text_box = $TextBox

const territoryTypes = {'FRIENDLY': -1, 'NEUTRAL': 0, 'HOSTILE': 1}
var territoryType = territoryTypes.get('NEUTRAL')
var temperature = 0

func _ready():
	dude_guy.setPerception(territoryType)
	dude_guy.setTemperature(temperature)
#region Emotion Buttons
func _on_amazed_pressed():
	dude_guy.setEmotion("Amazed")

func _on_angry_pressed():
	dude_guy.setEmotion("Angry")

func _on_default_pressed():
	dude_guy.setEmotion("default")

func _on_disgusted_pressed():
	dude_guy.setEmotion("Disgusted")

func _on_happy_pressed():
	dude_guy.setEmotion("Happy")

func _on_love_pressed():
	dude_guy.setEmotion("Love")

func _on_pain_pressed():
	dude_guy.setEmotion("Pain")

func _on_sad_pressed():
	dude_guy.setEmotion("Sad")

func _on_scared_pressed():
	dude_guy.setEmotion("Scared")

func _on_wonder_pressed():
	dude_guy.setEmotion("Wonder")
#endregion

func _on_unlock_achievement_pressed():
	$UI/ControlSignals/Label.visible = true
	$UI/ControlSignals/LabelTimer.start()
	dude_guy.setEmotion("Happy")

func _on_label_timer_timeout():
	$UI/ControlSignals/Label.visible = false

func _on_talk_button_pressed():
	dude_guy.talk($UI/ControlVoice/TextEdit.text)

func _on_dude_guy_talking_signal(text):
	text_box.setText(text)
