extends Node2D

var scene_to_change_to: String = "res://features/stages/tutorial_stage.tscn"

@onready var progress_bar: ProgressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.z_index = 100
	ResourceLoader.load_threaded_request(scene_to_change_to)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var progress: Array
	ResourceLoader.load_threaded_get_status(scene_to_change_to, progress)
	progress_bar.value = progress[0]
	if is_equal_approx(progress[0], 1.0):
		var scene = ResourceLoader.load_threaded_get(scene_to_change_to).instantiate()
		scene.z_index = 0
		add_sibling(scene)
		var tween := get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 0, 2.5)
		await tween.finished
		queue_free()
