extends Control

const BUTTON_SCROLL_SPEED: float = 100

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
	Global.load_new_scene("res://features/stages/tutorial_stage.tscn", self)


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
