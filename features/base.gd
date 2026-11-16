extends Obstacle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.base_position = self.global_position
	
	$Ratticus.play("angry")
	$SpeechBubble.say("YOU REMEMBER YOUR MISSION, RIGHT?")
	$SpeechBubble.say("GET THE SEEDS. AVOID THE ENEMY.")
	$SpeechBubble.say("RETURN HERE WHEN YOU ARE FINISHED.")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Global.player:
		if Global.seeds_collected >= Global.seeds_per_stage[Global.current_stage]:
			print("At base")
			await $SpeechBubble.say("FINALLY, YOU GOT THE SEEDS. LET'S LEAVE, QUICK", true)
			# Play an animation
			add_sibling(load("res://features/stages/level_complete_screen.tscn").instantiate())
			Global.player_immune = true
			await get_tree().create_timer(3).timeout
			self.queue_free()
		else:
			$SpeechBubble.say("PONCHO! WHAT ARE YOU DOING? GET ME THE SEEDS, QUICK!!")
			$SpeechBubble.say("WELL WHAT ARE YOU WAITING FOR?")
			$SpeechBubble.say("GET ON IT AND DON'T LET IT CATCH YA")
