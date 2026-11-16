extends Control

## Cost of option in coins
@export var cost: float
@export var option_name: String
@export var option_image: Texture2D
@export var option_id: int
@export var disabled: bool = false


func _process(_delta: float) -> void:
	update_option()

func update_option() -> void:
	$Label.text = option_name + "\nCost: " + str(cost)
	$TextureRect.texture = option_image
	$Button.disabled = disabled
