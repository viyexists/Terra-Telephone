class_name Subarea
extends Node2D

@export var supports_radiation = false

func _enter_tree() -> void:
	Global.current_stage_node = self
