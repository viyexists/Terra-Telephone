extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.seeds_collected = 0


func _on_player_end_stage() -> void:
	await get_tree().create_timer(3).timeout
	self.queue_free()
	

func _on_base_end_stage() -> void:
	await get_tree().create_timer(3).timeout
	self.queue_free()
