extends CanvasLayer

func _on_continue_button_pressed() -> void:
	Global.current_stage_node.process_mode = Node.PROCESS_MODE_INHERIT
	queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		#await get_tree().process_frame
		#await get_tree().process_frame
		Global.current_stage_node.process_mode = Node.PROCESS_MODE_INHERIT
		queue_free()

func _on_quit_button_pressed() -> void:
	Global.load_new_scene("res://features/menus/main_menu.tscn", Global.current_stage_node)
