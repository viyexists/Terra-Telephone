extends Base

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.base_position = self.global_position
	
	var player = get_parent().get_node("Player")
	await get_tree().process_frame
	player.set_physics_process(false)
	player.flip_sprite(true)
	for enemy in get_parent().get_node("Enemies").get_children():
		enemy.speed = 0
	
	$Ratticus.play("angry")
	await $SpeechEngine.say("PONCHO LISTEN TO ME", true)
	await $SpeechEngine.say("HEIDI SAID THERE WERE SEEDS INSIDE THE POWER PLANT", true)
	await $SpeechEngine.say("IT'S A LITTLE BIT RUN DOWN BUT YOU'LL MAKE DO", true)
	
	player.set_physics_process(true)
	
	for enemy in get_parent().get_node("Enemies").get_children():
			enemy.speed = 0.8
			
	await $SpeechEngine.say("IT'S ALSO RADIOACTIVE SO HURRY", true)
	await $SpeechEngine.say("RETURN HERE WHEN YOU ARE FINISHED", true)

	
