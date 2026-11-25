extends Node

# "NAME": {"image": path, "cooldown": float, "unlocked": bool, "slot": int}
# Slots which are not [0, 1] aren't usable in game
# Players can only hold two spells at once
var spells = {
	"Turn Oranges into Apples": {
		"cooldown": 2.0, # seconds
		"unlocked": false, # unused
		"slot": 1
	}
}

const heldSpells = [
	"Turn Oranges into Apples"
]

func TurnOrangeTreesIntoAppleTrees():
	if not is_instance_valid(spells["Turn Oranges into Apples"].get("cooldownTimer")):
		var timer = Timer.new()
		timer.wait_time = spells["Turn Oranges into Apples"]["cooldown"]
		timer.one_shot = true
		add_child(timer)
		spells["Turn Oranges into Apples"]["cooldownTimer"] = timer
	if spells["Turn Oranges into Apples"]["cooldownTimer"].is_stopped():
		var orange_tree = get_nearest_in_group_from_player("orange_tree")
		if orange_tree == null: return
		orange_tree.add_to_group("changing")
		spells["Turn Oranges into Apples"]["cooldownTimer"].start()

		var initial_tree_position = orange_tree.global_position
		var shake_duration: float = 3
		var shake_count: int = 300
		var shake: float = 1.2

		for i in shake_count:
			if not is_instance_valid(orange_tree):
				return
			
			orange_tree.global_position = initial_tree_position + Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
			shake *= 1.01
			await get_tree().create_timer(shake_duration / shake_count).timeout
		
		if not is_instance_valid(orange_tree):
			return
		
		var parent = orange_tree.get_parent()
		if not is_instance_valid(parent):
			return
		
		var apple_tree = load("res://features/environment/tree_apple.tscn").instantiate()
		orange_tree.get_parent().add_child(apple_tree)
		apple_tree.global_position = initial_tree_position
		orange_tree.queue_free()
	
func get_nearest_in_group_from_player(group: String) -> Node:
	var nearest_node: Node = null
	var shortest_distance = INF
	
	for node in get_tree().get_nodes_in_group(group):
		if node is Node2D and not node.get_groups().has("changing"):
			var dist = Global.player.global_position.distance_squared_to(node.global_position)
			if dist < shortest_distance:
				shortest_distance = dist
				nearest_node = node
	return nearest_node
