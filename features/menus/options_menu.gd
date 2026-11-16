extends Control

@onready var volume_label: Label = $MarginContainer/Panel/VBoxContainer/HBoxContainer/VolumeLabel
@onready var volume_slider: HSlider = $MarginContainer/Panel/VBoxContainer/HBoxContainer/VolumeSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume_slider.value = 50


func _on_close_button_pressed() -> void:
	self.queue_free()


func _on_volume_slider_value_changed(value: float) -> void:
	volume_label.text = "Volume: " + str(value)
