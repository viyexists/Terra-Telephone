extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _input(event):
	if event.is_action_pressed("interact"):
		for body in get_overlapping_bodies():
			if not body is Player: continue
			level_2_chernobyl_control_room.AZ5Initiated = true
			body.get_node("InteractionLabel").visible = false
			get_parent().get_node("AZ5Audio").play()

func _on_body_entered(body: Node2D) -> void:
	if not body is Player: return
	if not level_2_chernobyl_control_room.AZ5Initiated:
		body.get_node("InteractionLabel").visible = true
		body.get_node("InteractionLabel").text = "[E] Initiate AZ-5 "
	else:
		body.get_node("InteractionLabel").visible = false

func _on_body_exited(body: Node2D) -> void:
	if not body is Player: return
	body.get_node("InteractionLabel").visible = false
