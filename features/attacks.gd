extends Marker2D

@export var tomato: PackedScene

var current_attack = 'tomato'
@export var attack_marker: Sprite2D#Marker2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack(current_attack)
	

func attack(a)->void:
	var t = tomato.instantiate()
	t.global_position = self.global_position
	t.source = self.global_position
	t.target = get_global_mouse_position()
	Global.current_stage_node.add_child(t)
