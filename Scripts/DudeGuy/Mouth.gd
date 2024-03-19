extends Sprite2D

#region Privated Variables
@onready var _animationPlayer= $AnimationPlayer
var _actualEmotion = 'default'
#endregion

func _ready():
	_animationPlayer.current_animation = "default"

func _getVocals(words: String) -> String:
	#people only express vowels with their mouth
	#CONVERTS ALEJANDRO MARTIN LODES
	#INTO     AAEEAAAOO AAAIII OOOEE
	#print_debug (words)
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
						"QUE": "QEE",#only for Spanish
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

	#print_debug ("Output: " + response)
	return response

func articulate(words: String) -> void:
	#animate the mouth
	if (_animationPlayer.is_playing()): _animationPlayer.clear_queue() #Prevents words from accumulating
	var vocals: String = _getVocals(words)
	const ACCEPT: String = "AEIOU"
	
	for caracter in vocals:
		if caracter in ACCEPT:
			_animationPlayer.queue(caracter)
		else:
			_animationPlayer.queue('default')
	
	_animationPlayer.queue('default') # Closes the mouth
	_animationPlayer.queue(_actualEmotion) # back to emotion

func setEmotion(newEmotion: String):
	if _animationPlayer.has_animation(newEmotion):
		_actualEmotion = newEmotion
		_animationPlayer.queue(_actualEmotion)
	else:
		print_debug("ERROR: the animation doesnt exist " + newEmotion)
		_actualEmotion = 'default'
