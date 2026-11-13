extends Control

## Cost of option in coins
@export var cost: float
@export var option_name: String
@export var option_image: Texture2D

func _ready() -> void:
	$Label.text = option_name
	$TextureRect.texture = option_image
