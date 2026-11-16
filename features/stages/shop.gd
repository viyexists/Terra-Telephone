extends CanvasLayer

@onready var options_container: HBoxContainer = $UI/OptionsContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	$SpeechBubble.say("Hello!")
	$SpeechBubble.say("Welcome to my shop! What would you like today?")


func _on_continue_button_pressed() -> void:
	Global.current_stage += 1
	Global.current_stage %= Global.stages.size()
	Global.load_new_scene(Global.stages[Global.current_stage], self)
	self.queue_free()


func option_chosen(index: int) -> void:
	var cur_option: Control = options_container.get_child(index)
	if cur_option.cost > Global.coins:
		print("Not enough coins to buy this")
		return
	Global.coins -= cur_option.cost
	Items.bought_items.push_back(cur_option.option_id)
	cur_option.disabled = true
	
