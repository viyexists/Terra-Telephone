@tool
extends Marker2D
class_name EntitySpawner

@export var entity: PackedScene:
	set(e): entity = update_entity_display(e)

@export_category("Spawner")
## Specifies if the spawner only triggers once.
## If max_entities > 1, it spawns one entity every spawn_rate and after max_entities it turns off
@export var oneshot: bool = true
## Should the spawner spawn all it's enemies at once or gradually (following the spawn rate)
@export var burst: bool = false
## Spawn an entity every # seconds (default: 30)
@export_range(0, 3600,1) var spawn_rate:int = 30
## Maximum amount of entities from this spawner
@export_range(0, 100,1) var max_entities: int = 1
## Amount of entities spawned at once
@export_range(0, 100,1) var amount: int = 1:
	set(a): amount = min(max_entities, a)

@export_category("Conditions")
## When to spawn entities
## 0 - Always
## 1 - When player enters area
## 2 - When player leaves area
## 3 - When player is inside area (only effective if not oneshot)
## 4 - When player is outside area (only effective if not oneshot)
@export_enum("Always", "Enters", "Exits", "Inside", "Outside") var mode:int=0
@export var area: Area2D 

var cooldown: Timer
var total_spawns = 0

var player_in_area:= false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		update_entity_display(null)
	
		if area and mode!=0:
			area.connect('body_entered', _on_body_entered)
			area.connect('body_exited', _on_body_exit)
		else:
			spawn_entity()
			cooldown = Timer.new()
			cooldown.connect('timeout', spawn_entity)
			add_sibling.call_deferred(cooldown)
			cooldown.start.call_deferred(spawn_rate)

func _on_body_entered(body: Node2D)->void:
	if body == Global.player:
		player_in_area = true
		cooldown.start()

func _on_body_exit(body:Node2D)->void:
	if body == Global.player:
		player_in_area = false
		if mode == 2:
			cooldown.start()

func spawn_entity()->bool:
	# oneshot
	if oneshot and total_spawns >= amount:
		cooldown.stop()
		return false
		
	if entity:
		# not oneshot
		if len(get_children()) < max_entities:
			if burst:
				# Continous spawning in bursts of `amount`
				var spawned = 0
				while spawned < amount and len(get_children()) < max_entities:
					var e = entity.instantiate()
					add_child(e)
					total_spawns += 1
				return spawned != 0
			else:
				# Continous spawning of single entities
				var e = entity.instantiate()
				add_child(e)
				total_spawns += 1
				return true

	return false


func update_entity_display(ent: PackedScene):

	if get_child_count() > 0:
		self.get_child(0).free()
	
	if not ent:
		return null

	var e = ent.instantiate()
	e.modulate.a = 0.5
	add_child(e)
	return ent
