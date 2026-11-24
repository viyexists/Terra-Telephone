extends CanvasLayer

var scene_to_change_to: String

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var loading_label: Label = $LoadingLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("now loading " + scene_to_change_to)
	self.layer = 100
	# Thread loading doesn't work on web
	ResourceLoader.load_threaded_request(scene_to_change_to, "", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# $LoadingLabel.text += ". " # Can be added back later, but redundant
	var progress: Array
	ResourceLoader.load_threaded_get_status(scene_to_change_to, progress)
	progress_bar.value = progress[0]
	if is_equal_approx(progress[0], 1.0):
		set_process(false)
		await get_tree().create_timer(1.0).timeout
		var scene = ResourceLoader.load_threaded_get(scene_to_change_to).instantiate()
		if scene is Node2D:
			scene.z_index = 0
		add_sibling(scene)
		$ProgressBar.hide()
		$LoadingLabel.hide()
		var tween := get_tree().create_tween()
		tween.tween_property($BlackBackground, "modulate:a", 0, 1.5)
		await tween.finished
		queue_free()
