extends Node

enum{
	ID, NAME, COST, IMAGE_PATH, ITEM_EFFECT
}

var all_items: Array[Array] = [
	# ID: int Name: String, cost: float, sprite: String, item effect: String
	[0, "Egg", 5.0, "res://assets/terra_assets/sprites/level/Egg.webp", "slowness"],
	[1, "Clover", 2.0, "res://assets/terra_assets/sprites/level/PlantClover2.webp", "less tax"],
	[2, "Mushroom", 3.0, "res://assets/terra_assets/sprites/level/Mushroom1.webp", "nothing"],
	[3, "Shiny Tablet", 9.0, "res://assets/custom/ButtonBattery.png", "super speed"],
	[4, "Puffball Mushroom", 6.5, "res://assets/terra_assets/sprites/level/Mushroom7.webp", "inverted controls"]
]

var bought_items: Array[int] = []
