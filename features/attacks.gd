extends Marker2D

@export var tomato: PackedScene

var current_attack = 'tomato'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack(current_attack)

func attack(a)->void:
	print('attack: ', a)
	var t = tomato.instantiate()
	t.transform = self.transform
	add_sibling(t)
