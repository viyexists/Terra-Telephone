extends Node2D


func _enter_tree() -> void:
	Global.seeds_this_stage = Global.levels[Global.current_stage].seeds
	Global.current_stage_node = self
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		add_child(load("res://features/menus/pause_screen.tscn").instantiate())
		self.process_mode = Node.PROCESS_MODE_DISABLED


func _on_player_end_stage() -> void:
	add_sibling(load("res://features/stages/death.tscn").instantiate())
	await get_tree().create_timer(3).timeout
	self.queue_free()


func _on_base_end_stage() -> void:
	await get_tree().create_timer(3).timeout
	self.queue_free()
