# This was written by john
@tool
class_name RubbleScatter
extends Node2D

@export var sheet: Texture2D
@export var hframes := 4
@export var vframes := 2
@export var count := 60
@export var seed_value := 1
@export var area := Rect2(-2000, -1200, 4000, 2400)
@export var keep_out := Rect2()
@export_range(0.1, 5) var min_scale := 0.6
@export_range(0.1, 5) var max_scale := 1.2
@export var random_flip := true
@export_range(0, 45) var max_tilt_deg := 8.0
@export_tool_button("Scatter") var scatter_btn = func(): scatter()
@export_tool_button("Clear") var clear_btn = func(): clear()

func clear() -> void:
	for c in get_children():
		if c is Sprite2D:
			c.queue_free()

func scatter() -> void:
	if sheet == null:
		printerr("RubbleScatter: no sheet assigned")
		return
	clear()
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var placed := 0
	var tries := 0
	while placed < count and tries < count * 40:
		tries += 1
		var p := Vector2(rng.randf_range(area.position.x, area.end.x), rng.randf_range(area.position.y, area.end.y))
		if keep_out.size != Vector2.ZERO and keep_out.has_point(p):
			continue
		var s := Sprite2D.new()
		s.texture = sheet
		s.hframes = hframes
		s.vframes = vframes
		s.frame = rng.randi_range(0, hframes * vframes - 1)
		s.position = p
		s.scale = Vector2.ONE * rng.randf_range(min_scale, max_scale)
		s.rotation_degrees = rng.randf_range(-max_tilt_deg, max_tilt_deg)
		s.flip_h = random_flip and rng.randf() < 0.5
		add_child(s)
		if Engine.is_editor_hint():
			s.owner = get_tree().edited_scene_root
		placed += 1
	print("RubbleScatter: placed ", placed, " of ", count)
