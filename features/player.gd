extends CharacterBody2D

## Sent when we want to delete this stage e.g death or continuing
signal end_stage

var max_health: float = 10

@export var speed: float = 4e4
@export var health: float

@onready var player_body: AnimatedSprite2D = $Sprite/PlayerBody
@onready var player_clothes: AnimatedSprite2D = $Sprite/PlayerClothes

var is_controls_inverted: bool = false

func _ready() -> void:
	play_idle_animation()
	Global.player = self
	Global.player_immune = false
	health = max_health
	$ArrowToBase.hide()
	
	for item in Items.bought_items:
		if Items.all_items[int(item)][Items.ITEM_EFFECT] == "slowness":
			speed /= 2
		elif Items.all_items[int(item)][Items.ITEM_EFFECT] == "super speed":
			speed *= 2
		elif Items.all_items[int(item)][Items.ITEM_EFFECT] == "inverted controls":
			is_controls_inverted = true
	
	
func _process(_delta: float) -> void:
	$ArrowToBase.look_at(Global.base_position)

func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if is_controls_inverted:
		input_direction *= -1
	
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


func toggle_base_arrow(on: bool) -> void:
	if on:
		$ArrowToBase.show()
	else:
		$ArrowToBase.hide()


func take_damage(damage_taken: float) -> void:
	if Global.player_immune:
		return
	# Take damage effect
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 0.586, 0.525, 1.0), 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	tween.tween_property(self, "modulate", Color(1.0, 0.534, 0.469, 1.0), 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	health -= damage_taken
	if health <= 0:
		die()


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
	end_stage.emit()
	Global.coins = 0
	Items.bought_items.clear()
	

# TODO
func respawn() -> void:
	# Resetting everything that was changed
	$Hitbox.set_deferred("monitoring", true)
	$Hitbox.set_deferred("monitorable", true)
	$Sprite.position = Vector2.ZERO
	$Sprite.rotation = 0
	self.show()
