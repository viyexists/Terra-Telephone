extends CanvasLayer

@onready var black_background: Panel = $BlackBackground
@onready var restart_button: Button = $RestartButton
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	black_background.modulate.a = 0
	label.modulate.a = 0
	restart_button.modulate.a = 0
	var tween := get_tree().create_tween()
	tween.tween_property(black_background, "modulate:a", 1, 3)
	tween.tween_property(label, "modulate:a", 1, 2)
	tween.tween_property(restart_button, "modulate:a", 1, 1)
	


func _on_restart_button_pressed() -> void:
	# TODO Don't go back to the tutorial
	get_tree().change_scene_to_file("res://features/stages/tutorial_stage.tscn")
