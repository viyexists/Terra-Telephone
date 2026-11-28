extends Subarea

var controlRoom
var exploded: bool = false

func _process(dt) -> void:
	if level_2_chernobyl_control_room.exploded == true and not exploded:
		explode()
		exploded = true

# Call to set the scene to the exploded state
# irriversible
func explode():
	$ChernobylReactorHall.texture = load("res://assets/custom/chernobyl_reactor_hall_destroyed.png")
	$Explosion.visible = true
	for collisionShape in $Explosion/ExplisionCollsiions.get_children():
		collisionShape.disabled = false
