extends Obstacle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Ratticus.play("angry")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Global.player:
		print("player is here")
		$SpeechBubble.say("PONCHO! WHAT ARE YOU DOING? GET ME THE SEEDS, QUICK!!")
		$SpeechBubble.say("WELL WHAT ARE YOU WAITING FOR?")
		$SpeechBubble.say("GET ON IT AND DON'T LET IT CATCH YA")
