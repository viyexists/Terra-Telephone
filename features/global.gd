extends Node

var player: CharacterBody2D

## Is the player immune to damage? Used when the level ends so the player doesn't die when they finish.
var player_immune: bool = false

var player_inventory: Array[int]

var current_stage: int = 0
var current_stage_node: Node
var pending_spawn: Variant = null

var next_stage:
	get: return (current_stage + 1) % len(levels)

## The location of the place to return to
## used for the arrow to point towards
var base_position: Vector2

# Where to return the player to (position wise) on subarea exit
var return_position: Array[Dictionary] = []

var stages: Array[String] = [
	"res://features/stages/tutorial_stage.tscn",
]


## level/stage array. Stores the available levels and their status
## A locked stage needs its previous stages completed first.
var levels: Array[Dictionary] = [
	{"name": "Tutorial", "path": "res://features/levels/tutorial_stage.tscn", "seeds": 3, "unlocked": true},
	{"name": "Arrival", "path": "res://features/levels/1.tscn", "seeds": 3, "unlocked": true},
	{"name": "Kiev Oblast", "path": "res://features/levels/2.tscn", "seeds": 4, "unlocked": false},
	# Feel free to move the Kiev Oblast level further down, it's a little bit long
]


var coins: float = 0

## Seeds collected on the current stage
var seeds_collected: int = 0
var seeds_this_stage:int = 0

var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size


func coin_collected(value: float = 1) -> void:
	coins += value


func seed_collected() -> void:
	seeds_collected += 1
	Global.player.show_seed_collected()

# Load new scene resetting current seed and level seed count
# Used for going into new levels
func load_new_scene_reset_seeds(scene_to_load: String, scene_came_from: Node) -> void:
	seeds_collected = 0
	load_new_scene(scene_to_load, scene_came_from)

# Loads a new scene without resetting current seed and level seed count
# Used for subareas
func load_new_scene(scene_to_load: String, scene_came_from: Node) -> void:
	_drop_parked()
	var loading_screen: CanvasLayer = load("res://features/menus/loading_screen.tscn").instantiate()
	loading_screen.scene_to_change_to = scene_to_load
	get_tree().change_scene_to_node(loading_screen)
	scene_came_from.queue_free()

func _drop_parked() -> void:
	for entry in return_position:
		if is_instance_valid(entry.get("node")):
			entry.node.queue_free()
		for parked in entry.subarea.values():
			if is_instance_valid(parked):
				parked.queue_free()
	return_position.clear()
	pending_spawn = null

func _entry_for(outer: Node):
	for entry in return_position:
		if entry.node == outer:
			return entry
	return null

func _show_scene(node: Node) -> void:
	get_tree().root.add_child(node)
	get_tree().current_scene = node
	var found = node.find_child("Player", true, false)
	if found is Player:
		player = found

func enter_subarea(path: String, from: Node) -> void:
	var entry = _entry_for(from)
	if entry == null:
		entry = {"scene": from.scene_file_path, "node": from, "pos": Vector2.ZERO, "subarea": {}, "inside": false}
		return_position.push_back(entry)
	entry.pos = player.global_position
	entry.inside = true
	get_tree().root.remove_child(from)
	var key = ResourceUID.ensure_path(path)
	if is_instance_valid(entry.subarea.get(key)):
		var parked: Node = entry.subarea[key]
		entry.subarea.erase(key)
		_show_scene.call_deferred(parked)
		return
	var loading_screen: CanvasLayer = load("res://features/menus/loading_screen.tscn").instantiate()
	loading_screen.scene_to_change_to = path
	get_tree().root.add_child(loading_screen)

func exit_subarea(from: Node) -> void:
	for i in range(return_position.size() - 1, -1, -1):
		var entry: Dictionary = return_position[i]
		if not entry.inside: continue
		
		entry.inside = false
		entry.subarea[from.scene_file_path] = from
		get_tree().root.remove_child(from)
		_show_scene.call_deferred(entry.node)
		return
	push_warning("No return :<")
