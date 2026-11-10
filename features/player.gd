extends CharacterBody2D

@export var speed = 4e4

func _ready() -> void:
	play_idle_animation()

func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed * delta
	
	if input_direction.x > 0:
		flip_sprite(false)
	elif input_direction.x < 0:
		flip_sprite(true)
		
	if velocity != Vector2.ZERO:
		play_walk_animation()
	else:
		play_idle_animation()

	move_and_slide()
	
	Global.player_position = self.global_position


func play_idle_animation() -> void:
	$PlayerBody.play("idle")
	$PlayerClothes.play("idle")
	
	
func play_walk_animation() -> void:
	$PlayerBody.play("walk")
	$PlayerClothes.play("walk")


func flip_sprite(flipped: bool) -> void:
	if flipped:
		$PlayerBody.flip_h = true
		$PlayerClothes.flip_h = true
	else:
		$PlayerBody.flip_h = false
		$PlayerClothes.flip_h = false
