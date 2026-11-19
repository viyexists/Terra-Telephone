extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i = 1
	for level in Global.levels:
		var b = Button.new()
		b.connect('pressed', func():_load_level(Global.levels.get(level)))
		b.custom_minimum_size = Vector2(80,80)
		b.text = '%s - %s' % [i, level]
		%ButtonContainer.add_child(b)
		i += 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _load_level(level_path)->void:
	Global.load_new_scene(level_path, self)

func _on_close_button_pressed() -> void:
	self.queue_free()
