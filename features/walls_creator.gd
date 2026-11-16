## This script is used in the _editor only_ to create walls quicker.

"""

					How To Use
Add a Line2D named Line2D as a child to this node (which should be Node2D)
Arrange the line so each point is where you want a wall to be.
Then, tick the boolean "Activate Wall Creator" and "Confirm Modification" in the inspector
and a bunch of Node2Ds will be added as a child to this node.
Tick "Clear Walls" and "Confirm Modification" to delete all walls.
Note: Changes are not undoable. Unless you use git I guess.

You may have to redo this multiple times or change the min/max wall scale
to ensure that there are no gaps in the wall.
This doesn't support separated walls, so use a separate node for each wall.

You don't have to use rocks, you can also make your own obstacles and add it to the wall variants
array to use those instead (e.g, bush walls, trees, etc).
Make sure any new nodes you make have a collision shape so the
player cannot walk through them.

"""

@tool
extends Node2D

const Y_POSITION_DIVISOR: float = 25

@export var activate_wall_creator: bool = false
@export var clear_walls: bool = false
@export var confirm_modification: bool = false
@export var wall_variants: Array[PackedScene]

@export_range(0.1, 5) var min_wall_scale: float = 0.7
@export_range(0.1, 5) var max_wall_scale: float = 1.3

func _ready() -> void:
	# If not in editor
	if Engine.is_editor_hint() == false:
		get_node("Line2D").queue_free()

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
		cur_wall.original_z_index = int(cur_wall.position.y / Y_POSITION_DIVISOR)
		
		add_child(cur_wall)
		cur_wall.owner = get_tree().edited_scene_root
		

func remove_obstacles() -> void:
	for child in get_children():
		if child is Obstacle:
			child.queue_free()
