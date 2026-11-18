extends Marker2D

@export var tomato: PackedScene

var current_attack = 'tomato'
@export var attack_marker: Sprite2D#Marker2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#attack_marker = Marker2D.new()
	#attack_marker = $Sprite2D
	add_child(attack_marker)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		self.look_at(get_global_mouse_position())
		attack(current_attack)
	attack_marker.position = get_viewport().get_mouse_position()


func attack(a)->void:
	print('attack: ', a)
	var t = tomato.instantiate()
	t.transform = self.global_transform
	t.source = self.global_position
	t.target = attack_marker.global_position
	Global.current_stage_node.add_child(t)
