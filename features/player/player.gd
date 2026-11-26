@tool
class_name Player
extends CharacterBody2D

## Sent when we want to delete this stage e.g death or continuing
signal end_stage
signal reached_balloon

var max_health: float = 10
var moving_to_balloon: bool = false
var target: Vector2
var levelBalloon

# Debug
@export var DEBUG_vignette_enabled: bool = true:
	set(v):
		DEBUG_vignette_enabled = v
		set_vignette()

## How fast the player walks. This is occasionally modified by external sources.
@export var speed: float = 5.5
@export var health: float

# The player body and clothes are separate sprites.
@onready var player_body: AnimatedSprite2D = $Sprite/PlayerBody
@onready var player_clothes: AnimatedSprite2D = $Sprite/PlayerClothes

## If the controls are inverted, up is down, right is left, etc.
## This is caused when you obtain a certain item.
var is_controls_inverted: bool = false

var is_dead: bool = false

func _ready() -> void:
	if Engine.is_editor_hint(): return
	play_idle_animation()
	$UI.visible = true
	Global.player = self
	Global.player_immune = false
	health = max_health
	$ArrowToBase.hide()
	$SeedLabel.hide()
	
	# Applying the shop item effects
	for item in Items.bought_items:
		if Items.all_items[item][Items.ITEM_EFFECT] == "slowness":
			speed /= 2
		elif Items.all_items[item][Items.ITEM_EFFECT] == "super speed":
			speed *= 2
		elif Items.all_items[item][Items.ITEM_EFFECT] == "inverted controls":
			is_controls_inverted = true

# Annoying when you're trying to see stuff in the map, debug only
# or to be used on really bright maps where the vignette doesn't fit
func set_vignette():
	$UI/TextureRect.visible = DEBUG_vignette_enabled

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	$ArrowToBase.look_at(Global.base_position)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	if moving_to_balloon:
		play_walk_animation()
		global_position = global_position.move_toward(target, speed * 100 * delta)
		
		if global_position.distance_to(target) < 2.0:
			global_position = target
			play_idle_animation()
			reached_balloon.emit()
		return
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if is_controls_inverted:
		input_direction *= -1
	
	velocity = input_direction * speed * delta * 1e4
	
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
		#player_body.flip_h = true
		#player_clothes.flip_h = true
		$Sprite.scale.x = -1
	else:
		#player_body.flip_h = false
		#player_clothes.flip_h = false
		$Sprite.scale.x = 1


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
	
	
	#$Camera2D.add_trauma(5)
	
	health -= damage_taken
	if health <= 0:
		die()


func die() -> void:
	if is_dead:
		return
	is_dead = true
	$Hitbox.set_deferred("monitoring", false)
	$Hitbox.set_deferred("monitorable", false)
	var tween := get_tree().create_tween()
	tween.tween_property(self, "rotation", 6*PI, 1)
	tween.parallel().tween_property($Sprite, "position", Vector2(1000, 1000), 1)
	await tween.finished
	self.hide()
	self.set_physics_process(false)
	end_stage.emit()
	Global.coins = 0
	Items.bought_items.clear()
	


func show_seed_collected() -> void:
	$SeedLabel.show()
	await get_tree().create_timer(2).timeout
	$SeedLabel.hide()


# Set target for moving to the balloon
# Actually moves in _process
func go_to_balloon(Balloon) -> void:
	levelBalloon = Balloon
	
	for point in [1, 2]:
		var posA = levelBalloon.get_node("Start/Left").global_position if point == 1 else levelBalloon.get_node("End/Left").global_position
		var posB = levelBalloon.get_node("Start/Right").global_position if point == 1 else levelBalloon.get_node("End/Right").global_position
		var deltA = global_position.distance_squared_to(posA)
		var deltB = global_position.distance_squared_to(posB)
		
		target = posA if deltA <= deltB else posB 
		
		var direction = global_position.direction_to(target)
		flip_sprite(direction.x < 0)
			
		self.get_node("CollisionShape2D").set_deferred("disabled", true)
		moving_to_balloon = true
		
		while global_position.distance_to(target) > 2.0:
			await get_tree().physics_frame
		
		global_position = target
		# moving to balloon isnt set to false to prevent player inputs
		# this should've been called from base.gd as part of the finishing animation stuff
		play_idle_animation()


# DEPRECATED
# Was a TODO but retrying a level just uses die() which brings you back to the main menu
# die() is fine but this can be continued if you want to use respawn
func respawn() -> void:
	# Resetting everything that was changed
	$Hitbox.set_deferred("monitoring", true)
	$Hitbox.set_deferred("monitorable", true)
	$Sprite.position = Vector2.ZERO
	$Sprite.rotation = 0
	self.show()
