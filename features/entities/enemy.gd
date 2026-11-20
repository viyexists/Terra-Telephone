extends CharacterBody2D
class_name Enemy

signal attack

## The type of enemy
@export var type:String = 'blargh'
## Speed of the enemy, player default is 5.5
@export var speed: float = 0.8

@export var damage: float = 1

var _player_in_area: bool = false

# internal knockback tracker
var _knockback = Vector2.ZERO

## Time in between attack attempts
var attack_cooldown = 2.0
var current_cooldown = 0.0

## The list of attacks this enemy can make
## The default attack is named 'default_bite'
## It deals 2 damage
## Has a 1 second cooldown
## When adding a new attack, make sure it's name is the same as it's attack function
## The last field should remain EMPTY or NULL
@export var attack_list:Dictionary[String,Array] = {
	# 'attack_name' : [COOLDOWN, AVAILABLE, TIMER_DONT_TOUCH]
	'default_bite' : [2, 1, true, null]
}

## How quickly the enemy recovers from knockback
@export var knockback_resistance = 1

# Note that the shark has a z index of 60

func _ready() -> void:
	for attack in attack_list:
		var t = Timer.new()
		t.one_shot=true
		t.wait_time=attack_list[attack][1]
		t.connect('timeout',func(): _reset_cooldown(attack))
		add_child(t)
		attack_list[attack][3] = t
		
		

func _physics_process(delta: float) -> void:
	
	if Global.player == null:
		return
	
	# Movement
	var player_relative_direction: Vector2 = (Global.player.global_position - self.global_position).normalized()
	self.velocity = player_relative_direction * delta * speed
	
	# Knockback
	_knockback = _knockback.move_toward(Vector2.ZERO, knockback_resistance)
	velocity += _knockback * delta

	velocity *= 10000
	move_and_slide()

func _process(delta: float) -> void:
	# Damage
	if _player_in_area and current_cooldown <= 0.0:
		attempt_attack()
		current_cooldown = attack_cooldown
	current_cooldown -= delta


func attempt_attack()->void:
	var attack = attack_list.keys().pick_random()
	
	Callable(self, attack).call(attack)

func default_bite(attack)->void:
	Global.player.take_damage(attack_list[attack][0])
	_start_cooldown(attack)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == Global.player.get_node("Hitbox"):
		_player_in_area = true
		attack.emit()
		attempt_attack()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area == Global.player.get_node("Hitbox"):
		_player_in_area = false

func _start_cooldown(attack)->void:
	attack_list[attack][3].start()
	attack_list[attack][2] = false

func _reset_cooldown(attack)->void:
	attack_list[attack][2] = true
