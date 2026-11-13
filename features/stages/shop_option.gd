extends Control

## Cost of option in coins
@export var cost: float
@export var option_name: String
@export var option_image: Texture2D
@export var disabled: bool = false

func _ready() -> void:
	$Label.text = option_name
	$TextureRect.texture = option_image

func _process(_delta: float) -> void:
	if disabled:
		$Button.disabled = true
