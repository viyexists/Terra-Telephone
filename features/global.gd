extends Node

var player: CharacterBody2D

var current_stage: int = 0

var stages: Array[String] = [
	"res://features/stages/tutorial_stage.tscn",
]


var coins: float = 10

var seeds_collected: int = 3
var seeds_per_stage: Array[int] = [
	3,
]


func coin_collected(value: float = 1) -> void:
	coins += value


func seed_collected() -> void:
	seeds_collected += 1
