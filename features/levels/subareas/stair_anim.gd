# This script was written by John
extends Node2D

# Player z_index for the leg that ENDS at each keyframe (set here, so the Inspector
# values on the markers do not matter). Layers: 1StairsBack -3, 3HallFloor -2,
# 2StairsFront 0. Player -1 = above back flight and floor, behind the front layer.
# Legs: 1->2 lower flight | 2->3, 3->4, 4->5 landing | 5->6 upper flight
const Z_LEGS: Array[int] = [-1, -1, 1, 1, 1, 1]
const Z_AFTER := 1

var armed := true
var walking := false

func _ready() -> void:
	$Up.body_entered.connect(_on_up_entered)
	$Down.body_entered.connect(_on_down_entered)
	$Up.body_exited.connect(_on_exited)
	$Down.body_exited.connect(_on_exited)

func _on_up_entered(body: Node2D) -> void:
	if body is Player: _walk(false)

func _on_down_entered(body: Node2D) -> void:
	if body is Player: _walk(true)

func _on_exited(body: Node2D) -> void:
	if body is Player and not walking:
		armed = true

func _walk(reverse: bool) -> void:
	if not armed or walking: return
	armed = false
	walking = true
	var markers := $Keyframes.get_children()
	var points: Array[Vector2] = []
	var zs: Array[int] = []
	if not reverse:
		for i in markers.size():
			points.append(markers[i].global_position)
			zs.append(Z_LEGS[i])
	else:
		# down: the leg from marker j+1 to marker j uses the z of marker j+1
		for j in range(markers.size() - 1, -1, -1):
			points.append(markers[j].global_position)
			zs.append(Z_LEGS[min(j + 1, markers.size() - 1)])
	await Global.player.walk_path(points, -1, Z_AFTER, zs)
	walking = false
