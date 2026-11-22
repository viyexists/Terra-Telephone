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
	self.connect('body_entered', _on_body_entered)
	self.connect('body_exited', _on_body_exited)
	

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

func _on_body_entered(body) -> void:
	if body == Global.player:
		_player_in_area = true
		# player is in at least one area, +1
		enemy._player_in_area += 1

func _on_body_exited(body) -> void:
	if body == Global.player:
		_player_in_area = false
		# player exited at least one area, -1
		enemy._player_in_area -= 1
