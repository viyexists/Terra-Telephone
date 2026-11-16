extends Node2D
class_name Level

@export var player : Player
@export var base : Base



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.seeds_collected = 0
	Global.current_stage_node = self
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		add_child(load("res://features/menus/pause_screen.tscn").instantiate())
		self.process_mode = Node.PROCESS_MODE_DISABLED

func _on_player_end_stage() -> void:
	add_sibling(load("res://features/stages/death.tscn").instantiate())
	await get_tree().create_timer(3).timeout
	self.queue_free()
