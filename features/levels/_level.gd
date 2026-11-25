extends Node2D
class_name Level

@export var player : Player
@export var base : Base

## ALl enemies in the level, sorted by type
var current_enemies:Dictionary[String, Enemy] = {}


# Reset seed count (seed count automatically calculated in seed.gd)
func _enter_tree() -> void:
	Global.seeds_this_stage = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.seeds_collected = 0
	Global.current_stage_node = self
	
	# since we assign the player and base vars, and this script is shared,
	# we cant use godot's inbuilt signal connection and have to manually connect 
	# to the signals
	player.connect('end_stage', _on_player_end_stage)
	base.connect('end_stage', _on_base_end_stage)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		add_child(preload("res://features/menus/pause_screen.tscn").instantiate())
		self.process_mode = Node.PROCESS_MODE_DISABLED

func _on_player_end_stage() -> void:
	add_sibling(load("res://features/stages/death.tscn").instantiate())
	await get_tree().create_timer(3).timeout
	queue_free()

func _on_base_end_stage() -> void:
	#Global.player_immune = true
	#await get_tree().create_timer(3).timeout
	#add_sibling(load("res://features/stages/level_complete_screen.tscn").instantiate())
	self.queue_free()
