extends Panel
class_name SpeechBubble

signal message_completed

# Configurable styling options.
# Configured from SpeechEngine, but defaults are also included here.
var TIME_FOR_CHARACTER_TO_APPEAR: float = 0.03
var TIME_UNTIL_SPEECH_BUBBLE_GONE: float = 3.0
var TEXT_BACKGROUND_MARGIN: float = 30
var FONT_SIZE: int = 64
var AudioInstance: AudioStreamPlayer2D

var timer: Timer
var label: Label
var message: String = ''
## Disables the typing animation. Mostly for use within the editor.
## DO NOT SET TO TRUE WHEN USING WITH OTHER NON STATIC MESSAGES
## IT *WILL NOT* FREE ITSELF
var _static:bool = false

func _init(audio):
	AudioInstance = audio

func _ready():
	# Listen to if a message intterupts others
	self.get_parent().connect('messages_interrupted', _interrupt)
	
	if not _static:
		# setup timer, a new character appears every itnerval
		AudioInstance.play()
		timer = Timer.new()
		timer.autostart = false
		timer.wait_time = TIME_FOR_CHARACTER_TO_APPEAR
		timer.connect('timeout', _show_next_character)
		self.add_child(timer)
	
	# configuring label/text
	label = Label.new()
	label.hide()
	label.add_theme_font_size_override("font_size", FONT_SIZE)
	label.z_index = 5
	label.text = message
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	self.add_child(label)
	# styling
	self.size = label.size + Vector2(TEXT_BACKGROUND_MARGIN, TEXT_BACKGROUND_MARGIN/2)
	label.size = self.size
	
	if not _static:
		await get_tree().process_frame
		label.visible_characters = 0
		timer.start()
	
	label.show()
	self.show()

## Shows the next character.
## DO NOT CALL BY ITSELF
func _show_next_character()->void:
	label.visible_characters += 1

	if label.visible_characters >= len(message):
		# if entire message is displayed, go through message complete routine
		# timer is stopped for safety, it might fire while being freed
		AudioInstance.stop()
		timer.stop()
		await get_tree().create_timer(TIME_UNTIL_SPEECH_BUBBLE_GONE).timeout
		message_completed.emit()
		self.queue_free()

## If a message interrupts others, kill all current SpeechBubbles
func _interrupt()->void:
	# timer is stopped for safety, it might fire while being freed
	timer.stop()
	self.queue_free()
