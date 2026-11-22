class_name Base
extends Obstacle

## Sent when we want to move on e.g got all seeds
signal end_stage

var ended_stage: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.base_position = self.global_position
	
	$Ratticus.play("angry")
	$SpeechEngine.say("YOU REMEMBER YOUR MISSION, RIGHT?")
	$SpeechEngine.say("GET THE SEEDS. AVOID THE ENEMY.")
	$SpeechEngine.say("RETURN HERE WHEN YOU ARE FINISHED.")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Global.player:
		if Global.seeds_collected >= Global.seeds_this_stage and ended_stage == false:
			ended_stage = true
			await $SpeechBubble.say("FINALLY, YOU GOT THE SEEDS. LET'S LEAVE, QUICK", true)
			get_parent().add_sibling(load("res://features/stages/level_complete_screen.tscn").instantiate())
			Global.player_immune = true
			await get_tree().create_timer(3).timeout
			end_stage.emit()
		else:
			$SpeechEngine.say("PONCHO! WHAT ARE YOU DOING? GET ME THE SEEDS, QUICK!!")
			$SpeechEngine.say("WELL WHAT ARE YOU WAITING FOR?")
			$SpeechEngine.say("GET ON IT AND DON'T LET IT CATCH YA")
