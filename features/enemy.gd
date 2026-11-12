extends CharacterBody2D
class_name Enemy

@export var speed: float = 8000
@export var damage: float = 1

const ATTACK_COOLDOWN: float = 1
var cur_attack_cooldown: float = ATTACK_COOLDOWN
var _player_in_area: bool = false

# Note that the shark has a z index of 60

func _physics_process(delta: float) -> void:
	
	# Damage
	
	if _player_in_area and cur_attack_cooldown <= 0:
		Global.player.take_damage(damage)
		cur_attack_cooldown = ATTACK_COOLDOWN
	cur_attack_cooldown -= delta
	
	# Movement
	var player_relative_direction: Vector2 = (Global.player.global_position - self.global_position).normalized()
	self.velocity = player_relative_direction * delta * speed
	
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == Global.player.get_node("Hitbox"):
		_player_in_area = true
	


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area == Global.player.get_node("Hitbox"):
		_player_in_area = false
