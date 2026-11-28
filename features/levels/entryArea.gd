@tool
extends Area2D
# TODO: `exit_to_root` to exit all the way to the root node from a subarea
# These TODOs are listed within `docs/Subareas.md` as well,
# If you've completed any of them, please update the TODO items accordingly

@export var isExit: bool = false:
	set(v):
		isExit = v
		notify_property_list_changed()
@export_file("*.tscn") var area: String
@export var areaName: String = ""

func _validate_property(property: Dictionary) -> void:
	if (property.name == "area" or property.name == "areaName") and isExit:
		property.usage = PROPERTY_USAGE_NO_EDITOR

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _input(event):
	if event.is_action_pressed("interact"):
		for body in get_overlapping_bodies():
			if not body is Player: continue
			if not isExit:
				Global.enter_subarea(area, Global.current_stage_node)
			elif isExit:
				Global.exit_subarea(Global.current_stage_node)

func _on_body_entered(body: Node2D) -> void:
	if not body is Player: return
	if not isExit:
		body.get_node("InteractionLabel").visible = true
		body.get_node("InteractionLabel").text = "[E] Enter " + areaName
		body.get_node("ExitLabel").visible = false
	elif isExit:
		body.get_node("InteractionLabel").visible = false
		body.get_node("ExitLabel").visible = true

func _on_body_exited(body: Node2D) -> void:
	if not body is Player: return
	body.get_node("InteractionLabel").visible = false
	body.get_node("ExitLabel").visible = false
