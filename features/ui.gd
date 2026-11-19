extends CanvasLayer

@onready var coins_label: Label = $VBoxContainer/CoinsLabel
@onready var seeds_label: Label = $VBoxContainer/SeedsLabel
@onready var all_seeds_collected_label: Label = $AllSeedsCollectedLabel


func _ready() -> void:
	$AllSeedsCollectedLabel.hide()


func _process(_delta: float) -> void:
	coins_label.text = "Coins: " + str(Global.coins)
	seeds_label.text = "Seeds: " + str(Global.seeds_collected)
	$HealthBar.value = (Global.player.health / Global.player.max_health) * 100
	if Global.seeds_collected >= Global.seeds_per_stage[Global.current_stage]:
		$AllSeedsCollectedLabel.show()
		Global.player.toggle_base_arrow(true)
