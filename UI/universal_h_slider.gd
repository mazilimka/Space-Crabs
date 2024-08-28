extends HBoxContainer

signal value_changed

func _ready():
	set_value(5)

# назначить пороговые значения слайдеров
func set_min_max(min, max):
	pass

func _on_value_changed(value):
	set_value(value)

func set_value(value):
	%SpinBox.value = value
	%HSlider.value = value
	value_changed.emit(value)

func get_value(value):
	return %HSlider.value
