extends Node

var player: CharacterBody2D

var coins: float = 0

func coin_collected(value: float = 1) -> void:
	coins += value
