## This script makes it so if the player is in front of the line, the sprite
## will show as behind the player and vice versa.
## This scene should be added to the main scene, and a sprite2d should be added under it.
## The bottom of the sprite should be where the line is. Add a collision shape to it if you want the
## player to collide with it.

extends Node2D
class_name Obstacle

func _ready() -> void:
	$Line2D.queue_free()


func _physics_process(_delta: float) -> void:
	if Global.player.global_position.y < self.global_position.y:
		self.z_index = 50
	else:
		self.z_index = -50
