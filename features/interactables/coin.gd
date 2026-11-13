extends Node2D


func _ready() -> void:
	await get_tree().create_timer(randf_range(0, 2)).timeout
	$AnimationPlayer.play("float")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == Global.player.get_node("Hitbox"):
		collected()


func collected() -> void:
	Global.coin_collected()
	queue_free()
