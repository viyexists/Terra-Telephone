@tool
extends Control
class_name SpeechEngine

## CHild SpeechBubbles listen to this and free themselves when emitted.
signal messages_interrupted

@export_range(0.01,10,0.01) var TIME_FOR_CHARACTER_TO_APPEAR: float = 0.03
@export_range(0,60,0.1) var TIME_UNTIL_SPEECH_BUBBLE_GONE: float = 3
@export_range(0,120,5) var TEXT_BACKGROUND_MARGIN: float = 30
@export_range(0,96,1) var FONT_SIZE: int = 64:
	set(s): FONT_SIZE = _set_font_size(s)

## Holds the messages queued for playing
var message_queue:Array = []
var current_bubble:SpeechBubble

var disabled := false

func _ready() -> void:
	## Generates the placeholder message for placement in the editor.
	## Only in the editor (you do not need to add any functionality to remove it
	## the scene loads)
	if Engine.is_editor_hint():
		var b = SpeechBubble.new()
		b._static = true
		b.message = "Message will appear here"
		b.FONT_SIZE = FONT_SIZE
		add_child(b)

	
## This function displays the message in a text bubble.
## It can be used one after the other as it will wait for a previous
## message to be complete before starting itself.
func say(message: String, interrupt_previous_messages: bool = false) -> void:
	if disabled:
		return
	if interrupt_previous_messages:
		# if message interrupts others, kill all child SpeechBubbles
		messages_interrupted.emit()
	message_queue.append(message)
	_next_message()
	if interrupt_previous_messages:
		await current_bubble.message_completed

## Internal method to display the next message
func _next_message()->void:
	# if a message is currently playing
	if current_bubble:
		return
	var message = message_queue.pop_front()
	# check if a message is queued for playing
	if not message:
		return
		
	# generate a new SpeechBubble
	var bubble: SpeechBubble = SpeechBubble.new()
	bubble.TIME_FOR_CHARACTER_TO_APPEAR = TIME_FOR_CHARACTER_TO_APPEAR
	bubble.TIME_UNTIL_SPEECH_BUBBLE_GONE = TIME_UNTIL_SPEECH_BUBBLE_GONE
	bubble.FONT_SIZE = FONT_SIZE
	bubble.message = message
	bubble.connect('message_completed', _on_message_completed)
	current_bubble = bubble
	add_child(bubble)

## Listens to the SpeechBubbles completed signal
func _on_message_completed()->void:
	current_bubble = null
	_next_message()
	
func _set_font_size(s):
	get_child(0).free()
	var b = SpeechBubble.new()
	b._static = true
	b.message = "Message will appear here"
	b.FONT_SIZE = FONT_SIZE
	add_child(b)
	return s
