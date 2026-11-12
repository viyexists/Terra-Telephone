@tool
extends Node2D

@export var activate_wall_creator: bool = false
@export var clear_walls: bool = false
@export var confirm_modification: bool = false
@export var wall_variants: Array[PackedScene]

@export_range(0.1, 5) var min_wall_scale: float = 0.7
@export_range(0.1, 5) var max_wall_scale: float = 1.3

func _process(_delta: float) -> void:
	if activate_wall_creator == true and confirm_modification == true:
		activate_wall_creator = false
		confirm_modification = false
		create_walls()
		
	if clear_walls == true and confirm_modification == true:
		clear_walls = false
		confirm_modification = false
		remove_obstacles()
		
func create_walls() -> void:
	if wall_variants.size() == 0:
		printerr("No obstacles added to the wall varients array. Add obstacles from the scene tree.")
		return
	if min_wall_scale > max_wall_scale or max_wall_scale < min_wall_scale:
		printerr("Min and max scale are flipped")
		return
		
	remove_obstacles()
		
	var points: PackedVector2Array = $Line2D.points
	for point in points:
		var cur_wall: Obstacle = wall_variants.pick_random().instantiate()
		cur_wall.position = point
		cur_wall.scale = Vector2.ONE * randf_range(min_wall_scale, max_wall_scale)
		add_child(cur_wall)
		cur_wall.owner = get_tree().edited_scene_root
		

func remove_obstacles() -> void:
	for child in get_children():
		if child is Obstacle:
			child.queue_free()
