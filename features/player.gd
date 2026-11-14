extends CharacterBody2D

@export var speed: float = 4e4
@export var health: float = 10

@onready var player_body: AnimatedSprite2D = $Sprite/PlayerBody
@onready var player_clothes: AnimatedSprite2D = $Sprite/PlayerClothes


func _ready() -> void:
	play_idle_animation()
	Global.player = self
	Global.player_immune = false

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


func play_idle_animation() -> void:
	player_body.play("idle")
	player_clothes.play("idle")
	
	
func play_walk_animation() -> void:
	player_body.play("walk")
	player_clothes.play("walk")


func flip_sprite(flipped: bool) -> void:
	if flipped:
		player_body.flip_h = true
		player_clothes.flip_h = true
	else:
		player_body.flip_h = false
		player_clothes.flip_h = false



func take_damage(damage_taken: float) -> void:
	if Global.player_immune:
		return
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 0.586, 0.525, 1.0), 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	tween.tween_property(self, "modulate", Color(1.0, 0.534, 0.469, 1.0), 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	health -= damage_taken
	if health <= 0:
		die()

# TODO make a proper death loop
func die() -> void:
	$Hitbox.set_deferred("monitoring", false)
	$Hitbox.set_deferred("monitorable", false)
	var tween := get_tree().create_tween()
	tween.tween_property(self, "rotation", 6*PI, 1)
	tween.parallel().tween_property($Sprite, "position", Vector2(1000, 1000), 1)
	await tween.finished
	self.hide()
	add_sibling(load("res://features/stages/death.tscn").instantiate())
	self.set_physics_process(false)

# TODO
func respawn() -> void:
	# Resetting everything that was changed
	$Hitbox.set_deferred("monitoring", true)
	$Hitbox.set_deferred("monitorable", true)
	$Sprite.position = Vector2.ZERO
	$Sprite.rotation = 0
	self.show()
