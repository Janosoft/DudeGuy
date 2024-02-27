extends Sprite2D

@onready var head = $Head

func talk(words: String) -> void:
	head.talk(words)

func emotion(newEmotion: String):
	head.emotion(newEmotion)
