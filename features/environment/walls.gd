@tool
class_name Walls
extends Line2D


var wall_sprites: Array[Texture2D] = [
	load("res://assets/terra_assets/sprites/level/Rock1.webp"),
	load("res://assets/terra_assets/sprites/level/Rock2.webp"),
	load("res://assets/terra_assets/sprites/level/Rock3.webp"),
	load("res://assets/terra_assets/sprites/level/Rock4.webp"),
]
@export_tool_button('Generate Wall','Callable') var generate_wall_action:
	get: return func(): generate_wall()


func generate_wall():
	
	for child in self.get_children():
		child.free()
	
	for point in points:
		var s = Sprite2D.new()
		var random_sprite_idx = randi_range(0,len(wall_sprites)-1)
		s.texture = wall_sprites.get(random_sprite_idx)
		s.position = point + Vector2(randf_range(-100,100),randf_range(-100,100))
		s.scale *= randf_range(2.0,4.5)
		s.scale += Vector2(randf_range(-0.2,0.2),randf_range(-0.2,0.2))
		s.scale *= Vector2((-1 if randi_range(0,1) else 1),1)
		self.add_child(s)
		s.owner = self
