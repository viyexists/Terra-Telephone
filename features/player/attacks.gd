extends Marker2D

@export var tomato: PackedScene

var current_attack = 'tomato'
@export var attack_marker: Sprite2D#Marker2D
var tomato_cooldown = 0.35
var current_cooldown = 0.0
var mana_cost = 2
# Player literally spawns tomatoes out of thin air so I decided to have it use mana
# Also made it fire faster (1.0 -> 0.35)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack") and current_cooldown <= 0.0:
		attack(current_attack)
	current_cooldown -= _delta

func attack(a)->void:
	if Magic.mana < mana_cost: return
	var t = tomato.instantiate()
	t.global_position = self.global_position
	t.source = self.global_position
	t.target = get_global_mouse_position()
	Global.current_stage_node.add_child(t)
	current_cooldown = tomato_cooldown
	Magic.mana -= mana_cost
