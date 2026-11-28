extends Subarea

var controlRoom
var exploded: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	controlRoom = Global.return_position[-1].subarea.get("res://features/levels/subareas/2_control_room.tscn")

func _process(dt) -> void:
	if controlRoom.exploded == true and not exploded:
		explode()
		exploded = true

# Call to set the scene to the exploded state
# irriversible
func explode():
	$ChernobylReactorHall.texture = load("res://assets/custom/chernobyl_reactor_hall_destroyed.png")
	$Explosion.visible = true
	for collisionShape in $Explosion/ExplisionCollsiions.get_children():
		collisionShape.disabled = false
