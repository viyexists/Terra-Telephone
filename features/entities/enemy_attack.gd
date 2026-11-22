extends Area2D
class_name EnemyAttack

signal attacking(attack_name)

var _player_in_area: bool = false

## Name of the attack
@export var attack_name:String = "Attack"
## How much damage the enemy deals
@export var damage:float = 2.0
## How long before THIS attack can fire again
@export var cooldown:float = 1.0

var current_cooldown = 0.0
var enemy: Enemy

func _ready() -> void:
	if not enemy:
		self.queue_free()

func _process(delta: float) -> void:
	current_cooldown -= delta


## This function is what controls the damage and animation and stuff.
func attack():
	Global.player.take_damage(damage)

func attempt_attack() -> bool:
	if current_cooldown<=0.0 and _player_in_area:
		current_cooldown = cooldown
		attacking.emit(attack_name)
		attack()
		return true
	return false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == Global.player.get_node("Hitbox"):
		_player_in_area = true
		# player is in at least one area, +1
		enemy._player_in_area += 1

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area == Global.player.get_node("Hitbox"):
		_player_in_area = false
		# player exited at least one area, -1
		enemy._player_in_area -= 1
