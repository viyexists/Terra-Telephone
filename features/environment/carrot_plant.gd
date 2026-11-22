extends Obstacle

func _ready() -> void:
	$Label.hide()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Global.player:
		$Label.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == Global.player:
		$Label.hide()
