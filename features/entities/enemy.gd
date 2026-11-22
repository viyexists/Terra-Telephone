extends CharacterBody2D
class_name Enemy

signal attacking

## The type of enemy
@export var type:String = 'blargh'
## Speed of the enemy, player default is 5.5
@export var speed: float = 0.8

## internal: The number of areas the player is in
var _player_in_area: int = 0

# internal knockback tracker
var _knockback = Vector2.ZERO

## How quickly the enemy recovers from knockback
@export var knockback_resistance = 1


@export_category("Attacks")
## The list of attacks this enemy can make
## Attack nodes MUST be added for them to be registered
@export var attack_list:Array[EnemyAttack]
## Time in between attack attempts
@export var attack_cooldown:float = 2.0
var current_cooldown = 0.0

# Note that the shark has a z index of 60

func _ready() -> void:
	for attack in attack_list:
		attack.enemy = self


func _physics_process(delta: float) -> void:
	if Global.player == null:
		return
	
	# Movement
	var player_relative_direction: Vector2 = (Global.player.global_position - self.global_position).normalized()
	self.velocity = player_relative_direction * delta * speed
	
	$Sprite.scale.x = 1 if velocity.x >= 0 else -1
	
	# Knockback
	_knockback = _knockback.move_toward(Vector2.ZERO, knockback_resistance)
	velocity += _knockback * delta

	velocity *= 10000
	move_and_slide()

func _process(delta: float) -> void:
	if _player_in_area and current_cooldown <= 0.0:
		var attack = attack_list.pick_random()
		if attack:
			if attack.attempt_attack():
				current_cooldown = attack_cooldown
	current_cooldown -= delta
