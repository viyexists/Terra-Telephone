@tool
extends Marker2D
class_name EntitySpawner

@export var entity: PackedScene:
	set(e): entity = update_entity_display(e)

@export_category("Spawner")
## Spawn an entity every # seconds (default: 30)
@export var spawn_rate:int = 30
## Maximum amount of entities from this spawner
@export_range(0, 100,1) var max_entities: int = 1

var cooldown: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		cooldown = Timer.new()
		cooldown.connect('timeout', spawn_entity)
		add_sibling(cooldown)
		cooldown.start(spawn_rate)
		
		
func spawn_entity():
	if entity and len(get_children()) < max_entities:
		var e = entity.instantiate()
		e.modulate.a = 0.5
		add_child(e)


func update_entity_display(ent: PackedScene):
	if not ent:
		var c = self.get_child(0)
		if c:
			c.free()
		return null
	var e = ent.instantiate()
	e.modulate.a = 0.5
	add_child(e)
	return ent
