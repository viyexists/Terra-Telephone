extends Node
signal magic_update
signal mana_update
# TODO: Menu to switch magic between slots
# TODO: UI to indicate to the player a grimoire has been picked up 
# TODO: MAYBE adding spells into heidi's shop
# These TODOs are listed within `docs/Magic.md` as well,
# If you've completed any of them, please update the TODO items accordingly

# "NAME": {"icon": path, "cooldown": float, "unlocked": bool, "slot": int}
# Slots which are not [1, 2] aren't usable in game
# Players can only hold two spells at once
# Other spells are just...in inventory i guess
# Please put the slot as 0 initially, otherwise it will probably break grimoire collection
var spells = {
	"Turn Oranges into Apples": {
		"icon": "res://assets/custom/orangetoappleicon.png",
		"cooldown": 2.0, # seconds
		"unlocked": false,
		"slot": 0,
		"function": TurnOrangeTreesIntoAppleTrees,
		"mana": 5
	}
}

var mana: float = 100.0
var maxMana: float = 100.0
var experience: float = 0.0 # Invisible to the player, used with stuff like items
							# The more experience, the less mana the player spends on spells

# If any spells are unlocked (faster to access than looping through EVERY spell)
var unlocked = false

# Literally just unlocks it in there this did not need a separate function
# But conventions from `coin.gd` made me do it
func collect_grimoire(spell):
	if spells[spell].unlocked: return
	var highestSlot = -INF
	for spellf in spells: # spell was already used so i just labeled it spellf
		if spells[spellf].slot > highestSlot:
			highestSlot = spells[spellf].slot
	highestSlot += 1
	spells[spell].unlocked = true
	spells[spell].slot = highestSlot
	unlocked = true
	magic_update.emit()

# Actions for magic
func _input(event):
	if event.is_action_pressed("activate_magic"):
		for spell in spells:
			if spells[spell].slot == 1 and spells[spell].unlocked:
				spells[spell].function.call()
	
	if event.is_action_pressed("switch_magic"):
		print("switched")
		for spell in spells:
			if spells[spell].slot == 1 and spells[spell].unlocked:
				spells[spell].slot = 2
				magic_update.emit()
			elif spells[spell].slot == 2 and spells[spell].unlocked:
				spells[spell].slot = 1
				magic_update.emit()

func _process(dt: float):
	mana += 0.5 * (1.0 + experience) * dt
	mana = min(mana, maxMana)
	mana_update.emit()

# Spell that turns the nearest orange tree into an apple tree
func TurnOrangeTreesIntoAppleTrees():
	if not spells["Turn Oranges into Apples"].unlocked: return
	if not is_instance_valid(spells["Turn Oranges into Apples"].get("cooldownTimer")):
		var timer = Timer.new()
		timer.wait_time = spells["Turn Oranges into Apples"]["cooldown"]
		timer.one_shot = true
		add_child(timer)
		spells["Turn Oranges into Apples"]["cooldownTimer"] = timer
	if spells["Turn Oranges into Apples"]["cooldownTimer"].is_stopped():
		if mana < spells["Turn Oranges into Apples"].mana: return
		var nearest = get_nearest_in_group_from_player("orange_tree")
		var orange_tree = nearest[0] # node
		var closest_distance = nearest[1] # distance
		if orange_tree == null: return
		if closest_distance > (400.0 * 400.0): return  # compensate for squared distance
		orange_tree.add_to_group("changing")
		mana -= spells["Turn Oranges into Apples"].mana * (1.0 - experience) # Subtract some mana
		mana_update.emit()
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

func get_nearest_in_group_from_player(group: String) -> Array:
	var nearest_node: Node = null
	var shortest_distance = INF
	
	for node in get_tree().get_nodes_in_group(group):
		if node is Node2D and not node.get_groups().has("changing"):
			var dist = Global.player.global_position.distance_squared_to(node.global_position)
			if dist < shortest_distance:
				shortest_distance = dist
				nearest_node = node
	return [nearest_node, shortest_distance]
