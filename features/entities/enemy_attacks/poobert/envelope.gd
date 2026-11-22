extends Area2D

@export var speed = 5.0
@export var knockback_modifier = 10

var damage = 5.0

var source: Vector2
var target: Vector2
var tracer: Line2D
var lifetime: float = 1.0

func _ready() -> void:
	look_at(target)
	await  get_tree().create_timer(lifetime).timeout
	self.queue_free()

func _process(delta:float) -> void:
	$Sprite2D.rotate(12*delta)
	
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta * 400

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.player.take_damage(damage)
	if body.is_in_group("enemies"):
		return
		#body._knockback = self.global_position.direction_to(body.global_position) * knockback_modifier
	_start_break()
		
func _start_break()->void:
		$CPUParticles2D.emitting = true
		$Sprite2D.hide()
		$CollisionShape2D.queue_free()
	

func _on_cpu_particles_2d_finished() -> void:
	queue_free()
	
