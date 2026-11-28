class_name Subarea
extends Node2D

@export var supports_radiation = false
@export var player: Player

func _enter_tree() -> void:
	Global.current_stage_node = self

func _ready() -> void:
	player.connect('end_stage', _on_player_end_stage)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		add_child(preload("res://features/menus/pause_screen.tscn").instantiate())
		self.process_mode = Node.PROCESS_MODE_DISABLED

func _on_player_end_stage() -> void:
	add_sibling(load("res://features/stages/death.tscn").instantiate())
	await get_tree().create_timer(3).timeout
	queue_free()
