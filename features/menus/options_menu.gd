extends Control

const SETTINGS_PATH = "user://settings.cfg"
var config: ConfigFile = ConfigFile.new()
@onready var volume_label: Label = $MarginContainer/NinePatchRect/VBoxContainer/HBoxContainer/VolumeLabel
@onready var volume_slider: HSlider = $MarginContainer/NinePatchRect/VBoxContainer/HBoxContainer/VolumeSlider

# Settings
var MASTER_VOLUME: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume_slider.value = MASTER_VOLUME


func _on_close_button_pressed() -> void:
	self.queue_free()


# Someone please find a better way to handle inputs this CAN'T be the only way :sob:
func _on_volume_slider_value_changed(value: float) -> void:
	volume_label.text = "Volume: " + str(value)
	MASTER_VOLUME = value
	var masterBus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(masterBus, linear_to_db(MASTER_VOLUME / 100))


# esc event
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		self.queue_free()
		get_viewport().set_input_as_handled()


# Save settings
func save_settings() -> void:
	config.set_value("audio", "master_volume", MASTER_VOLUME)
	var err = config.save(SETTINGS_PATH)
	if err != OK:
		push_error("Settings miraculously failed to save")


# Load settings
func load_settings() -> void:
	var err = config.load(SETTINGS_PATH)
	# if settings doesn't exist, make one
	if err != OK:
		save_settings()
		return
	
	MASTER_VOLUME = config.get_value("audio", "master_volume", 100)
