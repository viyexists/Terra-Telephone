extends GutTest

# Test if pause menu works
func test_pausing_all_scenes(level = use_parameters(Global.levels)):
	var game = load(level.path).instantiate()
	add_child(game)
	
	# Test if PauseScreen is initially nonexistent
	assert_null(game.find_child("PauseScreen", true, false), "Scene should start without the pause menu")
	
	# Test if PauseScreen exists after pressing escape
	await press_esc()
	await get_tree().process_frame
	
	assert_not_null(game.find_child("PauseScreen", true, false), "Pause menu should open")
	
	# Test if PauseScreen doesn't exist after pressing escape
	await press_esc()
	await get_tree().process_frame
	
	assert_null(game.find_child("PauseScreen", true, false), "Pause menu should close")
	
	game.queue_free()

func press_esc():
	var event = InputEventKey.new()
	event.keycode = KEY_ESCAPE
	event.physical_keycode = KEY_ESCAPE
	event.pressed = true
	Input.parse_input_event(event)
	
	await get_tree().process_frame
	
	event = InputEventKey.new()
	event.keycode = KEY_ESCAPE
	event.physical_keycode = KEY_ESCAPE
	event.pressed = false
	Input.parse_input_event(event)
