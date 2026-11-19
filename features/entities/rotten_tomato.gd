extends Area2D

@export var speed = 6.0
@export var knockback_modifier = 10

var source: Vector2
var target: Vector2
var tracer: Line2D
var lifetime: float = 0.0

func _ready() -> void:
	look_at(target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.rotate(2*delta)
	
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta * 400
	#if $Sprite2D.visible:
		#var point = _quadratic_bezier(source, (source+target)/2,target, lifetime)
		#self.global_position = point
		#lifetime += delta*1.5
		#if point.is_equal_approx(target):
			#_start_break()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		return
	if body.is_in_group("enemies"):
		body.knockback = self.global_position.direction_to(body.global_position) * knockback_modifier
		print('hit enemy, applying knockback: ', body.knockback)
	_start_break()
		
func _start_break()->void:
		$CPUParticles2D.emitting = true
		$Sprite2D.hide()
		$CollisionShape2D.queue_free()
	
func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r

func _on_cpu_particles_2d_finished() -> void:
	queue_free()
	
