extends GutTest

# Tests if seed count is > 0
# Ignore this if your scene genuinely has no seeds
func test_seed_nonzero(level = use_parameters(Global.levels)):
	var game = load(level.path).instantiate()
	add_child(game)
	
	# Wait for game to do something
	for i in 5:
		await get_tree().process_frame
	
	assert_ne(Global.seeds_this_stage, 0, "Seed should be nonzero")
	
	game.queue_free()
