extends Node

enum{
	NAME, COST, IMAGE_PATH
}

var all_items: Array[Array] = [
	# Name: String, cost: float, sprite: String
	["Egg", 5.0, "res://assets/terra_assets/sprites/level/Egg.webp"],
	["Clover", 2.0, "res://assets/terra_assets/sprites/level/PlantClover2.webp"],
	["Mushroom", 3.0, "res://assets/terra_assets/sprites/level/Mushroom1.webp"],
	["Blue Mushroom", 9.0, "res://assets/terra_assets/sprites/level/Mushroom4.webp"],
	["Puffball Mushroom", 6.5, "res://assets/terra_assets/sprites/level/Mushroom7.webp"]
]

var bought_items: Array = []
