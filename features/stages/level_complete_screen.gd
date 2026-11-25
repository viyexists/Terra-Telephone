extends CanvasLayer

@onready var black_background: Panel = $BlackBackground
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var label: Label = $VBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tax: float = round(Global.coins / 2)
	var did_item_reduce_tax: bool = false
	for item in Items.bought_items:
		var current_item: Array = Items.all_items[int(item)]
		if current_item[Items.ITEM_EFFECT] == "less tax":
			tax -= 1
			did_item_reduce_tax = true
	Global.coins -= tax
	
	var coin_plural: String = "coins"
	if abs(tax) == 1.0:
		coin_plural = "coin"
	
	if tax > 0:
		label.text += "Ratticus has taken " + str(tax) + " " + coin_plural + " from you as tax."
	else:
		label.text += "Ratticus tried to take tax from you, but "
		if tax == 0 and did_item_reduce_tax:
			label.text += "somehow wasn't able to...?"
		elif tax == 0:
			label.text += "you were too broke..."
		elif tax < 0:
			label.text += "ended up giving you " + str(-tax) + " " + coin_plural + " instead...?"
	
	# These three .modulate.a were moved to fix flashing when level ends
	black_background.modulate.a = 0
	label.modulate.a = 0
	continue_button.modulate.a = 0
	# Added wait a frame so the label size updates
	# and it formats it correctly or something?
	await get_tree().process_frame
	$VBoxContainer.position.x = (Global.screen_size.x / 2) - ($VBoxContainer.size.x / 2)
	
	var tween := get_tree().create_tween()
	tween.tween_property(black_background, "modulate:a", 1, 3)
	tween.tween_property(label, "modulate:a", 1, 2)
	tween.tween_property(continue_button, "modulate:a", 1, 1)
	

func _on_continue_button_pressed() -> void:
	Global.load_new_scene("res://features/stages/shop.tscn", self)
