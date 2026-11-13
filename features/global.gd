extends Node

var player: CharacterBody2D

var current_stage: int = 0

var stages: Array[String] = [
	"res://features/stages/tutorial_stage.tscn",
]


var coins: float = 0

func coin_collected(value: float = 1) -> void:
	coins += value
