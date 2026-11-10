extends Control

signal _is_message_complete(message_no_complete: int)

const TIME_FOR_CHARACTER_TO_APPEAR: float = 0.03
const TIME_UNTIL_SPEECH_BUBBLE_GONE: float = 3

var _no_of_messages: int = 0
var _is_done_saying: bool = true

## This function displays the message in a text bubble.
## It can be used one after the other as it will wait for a previous
## message to be complete before starting itself.
func say(message: String) -> void:
	var this_message_no: int = _no_of_messages + 1
	_no_of_messages += 1
	var message_complete_no: int
	
	if this_message_no != 1:
		while message_complete_no != this_message_no - 1:
			message_complete_no = await self._is_message_complete
		
	_is_done_saying = false
	var label := $Label
	label.visible_characters = 0
	label.text = message
	while label.visible_characters < len(label.text):
		label.visible_characters += 1
		await get_tree().create_timer(TIME_FOR_CHARACTER_TO_APPEAR).timeout
	await get_tree().create_timer(TIME_UNTIL_SPEECH_BUBBLE_GONE).timeout
	$Label.text = ""
	_is_done_saying = true
	_is_message_complete.emit(this_message_no)
