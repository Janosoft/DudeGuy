extends Node2D

signal achievementUnlocked
@onready var dude_guy = $DudeGuy
@onready var text_box = $TextBox

const territoryTypes = {'FRIENDLY': -1, 'NEUTRAL': 0, 'HOSTILE': 1}
var territoryType = territoryTypes.get('NEUTRAL')
var temperature = 0

var dialogs : Dictionary = {
	"Striking": {
		1: ["Whoa, check that out, that's weird", "Wow, look over there, that's odd", "Take a look at that, it's pretty strange", "Oh my, what's that? That's unusual", "What's that? That's rather peculiar"]},
	"Aggressiveness":{
		0: ["Aww, that's so sweet!", "How adorable!", "Oh, that's just too cute","Look at that, it's heartwarming", "That's so precious!"],
		1: ["Oh no, that's terrifying!", "Yikes, I'm scared!", "That's giving me the creeps","I'm getting goosebumps", "Oh wow, that's really freaking me out!"]},
	"Temperature":{
		0: ["Ah, feels nice and warm over here", "It's cozy by this warmth", "Mmm, I can feel the heat, it's so comforting", "This warmth is just what I needed", "Oh, it's toasty around here, I love it"],
		1: ["Brr, it's chilly around here", "Feels cold over here, but refreshing", "I can feel the coolness, it's quite invigorating", "This cold is bracing, but in a good way", "It's icy around here, but I don't mind"]}
	}

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
