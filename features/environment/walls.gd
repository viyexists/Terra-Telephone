@tool
class_name Walls
extends Line2D


@export var wall_sprites: Array[Texture2D] = [
	load("res://assets/terra_assets/sprites/level/Rock1.webp"),
	load("res://assets/terra_assets/sprites/level/Rock2.webp"),
	load("res://assets/terra_assets/sprites/level/Rock3.webp"),
	load("res://assets/terra_assets/sprites/level/Rock4.webp"),
]
@export_tool_button('Generate Wall','Callable') var generate_wall_action = self.generate_wall()


func generate_wall():
	for child in self.get_children():
		child.queue_free()
	for point in points:
		var s = Sprite2D.new()
		var random_sprite_idx = randi() % len(wall_sprites)
		s.texture = wall_sprites.get(random_sprite_idx)
		s.position = point
		self.add_child(s)
