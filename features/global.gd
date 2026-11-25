extends Node

var player: CharacterBody2D

## Is the player immune to damage? Used when the level ends so the player doesn't die when they finish.
var player_immune: bool = false

var player_inventory: Array[int]

var current_stage: int = 0
var current_stage_node: Node

var next_stage:
	get: return (current_stage + 1) % len(levels)

## The location of the place to return to
## used for the arrow to point towards
var base_position: Vector2


var stages: Array[String] = [
	"res://features/stages/tutorial_stage.tscn",
]


## level/stage array. Stores the available levels and their status
## A locked stage needs its previous stages completed first.
var levels: Array[Dictionary] = [
	{"name": "Tutorial", "path": "res://features/levels/tutorial_stage.tscn", "unlocked": true},
	{"name": "Arrival", "path": "res://features/levels/1.tscn", "unlocked": true},
	{"name": "Debug Test", "path": "res://features/levels/2.tscn", "unlocked": false},
]


var coins: float = 0

## Seeds collected on the current stage
var seeds_collected: int = 0
var seeds_this_stage:int = 0
var seeds_per_stage: Array[int] = [
	3,
]

var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size


func coin_collected(value: float = 1) -> void:
	coins += value


func seed_collected() -> void:
	seeds_collected += 1
	Global.player.show_seed_collected()


func load_new_scene(scene_to_load: String, scene_came_from: Node) -> void:
	var loading_screen: CanvasLayer = load("res://features/menus/loading_screen.tscn").instantiate()
	loading_screen.scene_to_change_to = scene_to_load
	get_tree().change_scene_to_node(loading_screen)
	scene_came_from.queue_free()
	
