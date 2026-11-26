extends Node2D

const supports_radiation = true

func _enter_tree() -> void:
	Global.current_stage_node = self
