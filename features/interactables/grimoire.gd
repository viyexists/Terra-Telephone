extends Node2D

@export var spell: String = ""

func _ready() -> void:
	await get_tree().create_timer(randf_range(0, 2)).timeout
	$AnimationPlayer.play("grimoire_float")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == Global.player.get_node("Hitbox"):
		collected()


func collected() -> void:
	Magic.collect_grimoire(spell)
	queue_free()
