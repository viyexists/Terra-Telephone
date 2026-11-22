extends CanvasLayer

@onready var coins_label: Label = $VBoxContainer/CoinsLabel
@onready var seeds_label: Label = $VBoxContainer/SeedsLabel
@onready var all_seeds_collected_label: Label = $AllSeedsCollectedLabel


func _ready() -> void:
	$AllSeedsCollectedLabel.hide()
	Items.connect('item_bought', _on_item_bought)


func _process(_delta: float) -> void:
	coins_label.text = "Coins: " + str(Global.coins)
	seeds_label.text = "Seeds: " + str(Global.seeds_collected)
	$HealthBar.value = (Global.player.health / Global.player.max_health) * 100
	if Global.seeds_collected >= Global.seeds_per_stage[Global.current_stage]:
		$AllSeedsCollectedLabel.show()
		Global.player.toggle_base_arrow(true)

	$Inventory.visible = Input.is_action_pressed("show_items")
	if Input.is_action_just_pressed("test"):
		Items.buy(randi_range(0, len(Items.all_items)-1), true)

func _on_item_bought(id:int)->void:
	var cnode = $Inventory/GridContainer.get_node_or_null(Items.all_items[id][Items.NAME])
	if cnode:
		cnode.get_child(0).text = str(Items.bought_items.count(id))
	else:
		var t = TextureRect.new()
		t.texture = load(Items.all_items[id][Items.IMAGE_PATH])
		t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		t.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
		t.size = Vector2(80,80)
		t.custom_maximum_size = Vector2(80,80)
		t.custom_minimum_size = Vector2(80,80)
		t.name = Items.all_items[id][Items.NAME]
		
		var l = Label.new()
		l.add_theme_font_size_override('larger_font', 32)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		l.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		l.size = Vector2(40,40)
		#l.text = str(Items.bought_items.count(id))
		l.position = Vector2(40,40)
		t.add_child(l)
		$Inventory/GridContainer.add_child(t)
