extends CanvasLayer

@onready var black_background: Panel = $BlackBackground
@onready var continue_button: Button = $ContinueButton
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text += "Ratticus has taken " + str(int(round(Global.coins / 2))) + " coins from you as tax."
	Global.coins -= round(Global.coins / 2)
	black_background.modulate.a = 0
	label.modulate.a = 0
	continue_button.modulate.a = 0
	var tween := get_tree().create_tween()
	tween.tween_property(black_background, "modulate:a", 1, 3)
	tween.tween_property(label, "modulate:a", 1, 2)
	tween.tween_property(continue_button, "modulate:a", 1, 1)
	

func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://features/stages/shop.tscn")
