extends CanvasLayer

@onready var black_background: Panel = $BlackBackground
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var label: Label = $VBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text += "Ratticus has taken " + str(int(round(Global.coins / 2))) + " coins from you as tax."
	Global.coins -= round(Global.coins / 2)
	
	$VBoxContainer.position.x = (Global.screen_size.x / 2) - ($VBoxContainer.size.x / 2)
	
	black_background.modulate.a = 0
	label.modulate.a = 0
	continue_button.modulate.a = 0
	var tween := get_tree().create_tween()
	tween.tween_property(black_background, "modulate:a", 1, 3)
	tween.tween_property(label, "modulate:a", 1, 2)
	tween.tween_property(continue_button, "modulate:a", 1, 1)
	

func _on_continue_button_pressed() -> void:
	Global.load_new_scene("res://features/stages/shop.tscn", self)
