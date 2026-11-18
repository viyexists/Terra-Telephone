extends Area2D

@export var speed = 6.0
@export var knockback_modifier = 10

var source: Vector2
var target: Vector2
var tracer: Line2D
var lifetime: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tracer = Line2D.new()
	tracer.default_color = '#ff1010'

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.rotate(2*delta)
	
func _physics_process(delta: float) -> void:
	#position += transform.x * speed * delta * 400
	var point = _quadratic_bezier(source, Vector2((source.x+target.x)/3,(source.y + target.y)/3) ,target, lifetime)
	self.global_position = point
	tracer.add_point(point)
	lifetime += delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		return
	if body.is_in_group("enemies"):
		body.knockback = self.global_position.direction_to(body.global_position) * knockback_modifier
		print('hit enemy, applying knockback: ', body.knockback)
	$CPUParticles2D.emitting = true
	$Sprite2D.hide()
	
func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r

func _on_cpu_particles_2d_finished() -> void:
	queue_free()
