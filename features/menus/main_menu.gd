extends Control

const BUTTON_SCROLL_SPEED: float = 100

## What stage the game starts on. Defaults to "res://features/stages/tutorial_stage.tscn"
## But can be changed for debugging later levels.
@export var starting_stage: String = "res://features/stages/tutorial_stage.tscn"

@onready var buttons: Array[Button] = [
	%StartButton,
	%SettingsButton, 
	%QuitButton
]


func _process(delta: float) -> void:
	for button in buttons:
		button.position.x += delta * BUTTON_SCROLL_SPEED
		if button.position.x > 1200:
			button.position.x = -300


func _on_start_button_pressed() -> void:
	Global.load_new_scene(starting_stage, self)


func _on_settings_button_pressed() -> void:
	add_child(load("res://features/menus/options_menu.tscn").instantiate())


func _on_quit_button_pressed() -> void:
	get_tree().quit()
