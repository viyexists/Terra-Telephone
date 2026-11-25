extends CanvasLayer

@onready var black_background: Panel = $BlackBackground
@onready var restart_button: Button = $VBoxContainer/RestartButton
@onready var label: Label = $VBoxContainer/Label

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
	var stage = Global.current_stage_node
	Global.load_new_scene("res://features/menus/main_menu.tscn", stage if is_instance_valid(stage) else self)
	queue_free()
