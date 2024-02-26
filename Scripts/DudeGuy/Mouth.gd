extends Sprite2D

@onready var animationPlayer= $AnimationPlayer

var actualEmotion = 'default'

func _ready():
	animationPlayer.current_animation = "default"

func _getVocals(words: String) -> String:
	#CONVERTS ALEJANDRO MARTIN LODES
	#INTO     AAEEAAAOO AAAIII OOOEE
	print_debug ("Input: " + words)
	words = words.to_upper()
	var response: String = ""
	var lastVowel: String = ""
	const VOWELS = "AEIOUÁÉÍÓÚ"
	const SYMBOLS = ",. "
	const ACCEPT = VOWELS + SYMBOLS	
	const REPLACEMENTS = {
						"Á": "A",
						"É": "E",
						"Í": "I",
						"Ó": "O",
						"Ú": "U",
						"Y": "I",
						"QUE": "QEE",
					}

	#REMOVE THE ACCENTS OR FIX KNOWN WORDS
	for key in REPLACEMENTS.keys():
		words = words.replace(key, REPLACEMENTS[key])

	for i in range(words.length()):
		if words[i] not in ACCEPT:
			if i > 0 and words[i-1] in VOWELS:
				response += words[i-1]
				lastVowel = words[i-1]
			elif i < words.length() - 1 and words[i+1] in VOWELS:
				response += words[i+1]
				lastVowel = words[i+1]
			else:
				response += lastVowel
		else:
			response += words[i]

	print_debug ("Output: " + response)
	return response
