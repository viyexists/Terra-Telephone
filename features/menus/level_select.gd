extends Control

@export var bypass_level_lock : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(Global.levels)):
		var b = Button.new()
		b.connect('pressed', func():_load_level(i ,Global.levels[i][1]))
		b.custom_minimum_size = Vector2(80,80)
		b.text = '%s - %s' % [i+1, Global.levels[i][0]]
		b.disabled = not (Global.levels[i][2] or bypass_level_lock)
		%ButtonContainer.add_child(b)
		i += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _load_level(level_idx, level_path)->void:
	Global.load_new_scene(level_path, self)
	Global.current_stage = level_idx

func _on_close_button_pressed() -> void:
	self.queue_free()
