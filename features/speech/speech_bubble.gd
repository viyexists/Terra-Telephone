extends Control

signal _is_message_complete(message_no_complete: int)

const TIME_FOR_CHARACTER_TO_APPEAR: float = 0.03
const TIME_UNTIL_SPEECH_BUBBLE_GONE: float = 3

const TEXT_BACKGROUND_MARGIN: float = 30

var _no_of_messages: int = 0
var _is_done_saying: bool = true


## Creates the background for the speech bubble
func _create_speech_box() -> void:
	var new_panel := Panel.new()
	# This assumes that this node has one child which is the label
	new_panel.size = get_child(0).size + (Vector2(TEXT_BACKGROUND_MARGIN, 0))
	new_panel.position = get_child(0).position - Vector2(TEXT_BACKGROUND_MARGIN / 2, 0)
	add_child(new_panel)


## This function displays the message in a text bubble.
## It can be used one after the other as it will wait for a previous
## message to be complete before starting itself.
## Interrupting is not implemented
func say(message: String, interrupt_previous_messages: bool = false) -> void:
	var this_message_no: int = _no_of_messages + 1
	_no_of_messages += 1
	var message_complete_no: int
	
	if this_message_no != 1:
		while message_complete_no != this_message_no - 1:
			message_complete_no = await self._is_message_complete
	
	_is_done_saying = false
	var label := Label.new()
	label.add_theme_font_size_override("font_size", 36)
	label.z_index = 5
	label.visible_characters = -1
	label.text = message
	add_child(label)
	await get_tree().process_frame
	_create_speech_box()
	label.visible_characters = 0
	label.show()
	
	while label.visible_characters < len(label.text):
		label.visible_characters += 1
		await get_tree().create_timer(TIME_FOR_CHARACTER_TO_APPEAR).timeout
	await get_tree().create_timer(TIME_UNTIL_SPEECH_BUBBLE_GONE).timeout
	
	for child in get_children():
		child.queue_free()
	
	_is_done_saying = true
	_is_message_complete.emit(this_message_no)
