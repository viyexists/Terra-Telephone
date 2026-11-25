extends GutTest

# Test if levels can be finished
func test_pausing_all_scenes(level = use_parameters(Global.levels)):
	var game = load(level.path).instantiate()
	add_child(game)
	
	# Wait for game to do something
	await get_tree().process_frame
	
	var player: Player = game.find_child("Player", true, false)
	assert_not_null(player, "Player should exist in level")
	var seeds = game.find_child("Seeds", true, false).get_children()
	var base = game.find_child("Base", true, false)
	assert_not_null(base, "Base should exist in level")
	
	# Collect seeds
	var initial_count: int = Global.seeds_collected
	var seedCollected: int = 0
	for seed in seeds:
		player.global_position = seed.global_position
		await get_tree().physics_frame
		await get_tree().physics_frame
		seedCollected += 1
		assert_eq(Global.seeds_collected, initial_count + seedCollected, "Seed collected shouldve went up")
	
	# Test if base marks the level as finished
	player.global_position = base.global_position
	await get_tree().physics_frame
	await get_tree().physics_frame
	assert_true(base.ended_stage, "Base should mark the level as finished")
	
	game.queue_free()

func press_keycode(keycode: Key):
	var event = InputEventKey.new()
	event.keycode = keycode
	event.physical_keycode = keycode
	event.pressed = true
	Input.parse_input_event(event)
	
	await get_tree().process_frame
	
	event = InputEventKey.new()
	event.keycode = keycode
	event.physical_keycode = keycode
	event.pressed = false
	Input.parse_input_event(event)
