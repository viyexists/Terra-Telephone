extends Obstacle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Ratticus.play("angry")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Global.player:
		if Global.seeds_collected >= Global.seeds_per_stage[Global.current_stage]:
			await $SpeechBubble.say("FINALLY, YOU GOT THE SEEDS. LET'S LEAVE, QUICK")
			# Play an animation
			get_tree().change_scene_to_file("res://features/stages/shop.tscn")
		else:
			$SpeechBubble.say("PONCHO! WHAT ARE YOU DOING? GET ME THE SEEDS, QUICK!!")
			$SpeechBubble.say("WELL WHAT ARE YOU WAITING FOR?")
			$SpeechBubble.say("GET ON IT AND DON'T LET IT CATCH YA")
