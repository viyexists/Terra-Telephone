extends Area2D

@export var speed = 6.0
var target: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.rotate(0.01)
	
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta * 400



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		return
	if body.is_in_group("enemies"):
		body.knockback = self.global_position.direction_to(body.global_position) * 100
	$CPUParticles2D.emitting = true
	$Sprite2D.hide()
	



func _on_cpu_particles_2d_finished() -> void:
	queue_free()
