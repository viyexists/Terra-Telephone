extends Node

enum{
	NAME, COST, IMAGE_PATH, ITEM_EFFECT
}

var all_items: Array[Array] = [
	# Name: String, cost: float, sprite: String, item effect: String
	["Egg", 5.0, "res://assets/terra_assets/sprites/level/Egg.webp", "slowness"],
	["Clover", 2.0, "res://assets/terra_assets/sprites/level/PlantClover2.webp", "less tax"],
	["Mushroom", 3.0, "res://assets/terra_assets/sprites/level/Mushroom1.webp", "nothing"],
	["Blue Mushroom", 9.0, "res://assets/terra_assets/sprites/level/Mushroom4.webp", "super speed"],
	["Puffball Mushroom", 6.5, "res://assets/terra_assets/sprites/level/Mushroom7.webp", "inverted controls"]
]

var bought_items: Array = []
