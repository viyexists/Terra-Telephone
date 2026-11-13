extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UI.hide()
	opening_animation()
	
	for i in range($UI/OptionsContainer.get_child_count()):
		var option: Control = $UI/OptionsContainer.get_child(i)
		var button: Button = option.get_child(0)
		button.pressed.connect(option_chosen.bind(i))


func opening_animation() -> void:
	$AnimationPlayer.play("opening_animation")
	await $AnimationPlayer.animation_finished
	$UI.show()
	$SpeechBubble.say("Hello!")
	$SpeechBubble.say("Welcome to my shop! What would you like today?")


func _on_continue_button_pressed() -> void:
	Global.current_stage += 1
	Global.current_stage %= Global.stages.size()
	# Do a loading thingy here cause it takes some time
	get_tree().change_scene_to_file(Global.stages[Global.current_stage])


func option_chosen(index: int) -> void:
	pass
