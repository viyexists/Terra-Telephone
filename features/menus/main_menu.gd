extends Control

const BUTTON_SCROLL_SPEED: float = 100
const BUTTON_ROTATION_SPEED: float = 0.2

## What stage the game starts on. Defaults to "res://features/stages/tutorial_stage.tscn"
## But can be changed for debugging later levels.
### I have no clue what starting_stage does anymore, loading is handled from res://features/menus/level_select.gd
@export var starting_stage: PackedScene = load("res://features/levels/tutorial_stage.tscn")

@onready var buttons: Array[Button] = [
	%StartButton,
	%SettingsButton, 
	%QuitButton
]

## Set initial button positions
func _ready() -> void:
	var offset = get_viewport_rect().size.x / 3
	var i = 0
	for button in buttons:
		button.position.x = offset * (i + 0.5) - button.size.x / 2
		button.rotation = randf() * 360
		i += 1

## Scroll and rotate buttons
func _process(delta: float) -> void:
	for button in buttons:
		button.position.x += delta * BUTTON_SCROLL_SPEED
		button.rotation += delta * BUTTON_ROTATION_SPEED
		if button.position.x > get_viewport_rect().size.x:
			button.position.x = -button.size.x


func _on_start_button_pressed() -> void:
	add_child(load("res://features/menus/level_select.tscn").instantiate())


func _on_settings_button_pressed() -> void:
	add_child(load("res://features/menus/options_menu.tscn").instantiate())


func _on_quit_button_pressed() -> void:
	get_tree().quit()
