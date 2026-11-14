extends Node2D

var has_been_collected: bool = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == Global.player.get_node("Hitbox") and has_been_collected == false:
		collected()


func collected() -> void:
	Global.seed_collected()
	has_been_collected = true
	
