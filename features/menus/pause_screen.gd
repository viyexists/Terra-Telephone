extends CanvasLayer


func _on_continue_button_pressed() -> void:
	Global.current_stage_node.process_mode = Node.PROCESS_MODE_INHERIT
	queue_free()
