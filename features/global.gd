extends Node

var player: CharacterBody2D

## Is the player immune to damage?
var player_immune: bool = false

var current_stage: int = 0

var stages: Array[String] = [
	"res://features/stages/tutorial_stage.tscn",
]


var coins: float = 0

var seeds_collected: int = 0
var seeds_per_stage: Array[int] = [
	1,
]


func coin_collected(value: float = 1) -> void:
	coins += value


func seed_collected() -> void:
	seeds_collected += 1
