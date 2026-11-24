extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.seeds_collected = 0
	Global.current_stage_node = self


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		add_child(load("res://features/menus/pause_screen.tscn").instantiate())
		self.process_mode = Node.PROCESS_MODE_DISABLED


func _on_player_end_stage() -> void:
	add_sibling(load("res://features/stages/death.tscn").instantiate())
	await get_tree().create_timer(3).timeout
	self.queue_free()
	

func _on_base_end_stage() -> void:
	await get_tree().create_timer(3).timeout
	self.queue_free()
