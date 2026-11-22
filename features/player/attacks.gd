extends Marker2D

@export var tomato: PackedScene

var current_attack = 'tomato'
@export var attack_marker: Sprite2D#Marker2D
var tomato_cooldown = 1.0
var current_cooldown = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack") and current_cooldown <= 0.0:
		attack(current_attack)
	current_cooldown -= _delta

func attack(a)->void:
	var t = tomato.instantiate()
	t.global_position = self.global_position
	t.source = self.global_position
	t.target = get_global_mouse_position()
	Global.current_stage_node.add_child(t)
	current_cooldown = tomato_cooldown
