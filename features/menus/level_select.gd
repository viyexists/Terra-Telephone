extends Control

@export var bypass_level_lock : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for idx in Global.levels.size():
		var level = Global.levels[idx]
		var b = Button.new()
		b.connect("pressed", func():_load_level(idx, level.path))
		b.custom_minimum_size = Vector2(80,80)
		b.text = '%s - %s' % [idx + 1, level.name]
		b.disabled = not level.unlocked and not (bypass_level_lock and OS.is_debug_build())
		%ButtonContainer.add_child(b)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _load_level(level_idx, level_path)->void:
	Global.load_new_scene_reset_seeds(level_path, self)
	Global.current_stage = level_idx

func _on_close_button_pressed() -> void:
	self.queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		self.queue_free()
		get_viewport().set_input_as_handled()
