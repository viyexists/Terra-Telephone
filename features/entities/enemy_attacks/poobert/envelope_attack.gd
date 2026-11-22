extends EnemyAttack

@export var envelope: PackedScene

func attack()->void:
	if envelope:
		var e = envelope.instantiate()
		e.target = Global.player.global_position
		e.source = self.global_position
		e.global_position = self.global_position
		e.damage = damage
		Global.current_stage_node.add_child(e)
