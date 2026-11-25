extends CanvasLayer

@onready var options_container: HBoxContainer = $UI/OptionsContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BlackBackground.show()
	$UI.hide()
	opening_animation()
	
	_randomise_shop_items()
	
	for i in range($UI/OptionsContainer.get_child_count()):
		var option: Control = $UI/OptionsContainer.get_child(i)
		option.update_option()
		var button: Button = option.get_child(0)
		button.pressed.connect(option_chosen.bind(i))


func _process(_delta: float) -> void:
	$UI/CoinLabel.text = "Coins: " + str(Global.coins)


func _randomise_shop_items() -> void:
	for option in options_container.get_children():
		var random_item: Array = Items.all_items.pick_random()
		option.option_name = random_item[Items.NAME]
		option.cost = random_item[Items.COST]
		option.option_image = load(random_item[Items.IMAGE_PATH])
		option.option_id = random_item[Items.ID]


func opening_animation() -> void:
	$AnimationPlayer.play("opening_animation")
	await $AnimationPlayer.animation_finished
	$UI.show()
	var tween := get_tree().create_tween()
	tween.tween_property($BlackBackground, "modulate:a", 0, 0.5)
	$SpeechEngine.say("Hello!")
	$SpeechEngine.say("Welcome to my shop! What would you like today?")


func _on_continue_button_pressed() -> void:
	if Global.current_stage + 1 < Global.levels.size():
		Global.load_new_scene(Global.levels[Global.next_stage].path, self)
		Global.current_stage = Global.next_stage
	else:
		Global.load_new_scene("res://features/menus/main_menu.tscn", self)
		Global.current_stage = 0
	self.queue_free()


func option_chosen(index: int) -> void:
	var cur_option: Control = options_container.get_child(index)
	if Items.buy(cur_option.option_id):
		cur_option.disabled = true
		return
	$SpeechEngine.say("You don't have enough coins to buy this :<", true)
	print("Not enough coins to buy this")
	
