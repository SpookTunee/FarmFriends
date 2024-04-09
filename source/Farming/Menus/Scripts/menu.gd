extends Control

func _ready():
	$Settings/ColorFix/HBoxContainer/Sensitivity.value = ((get_parent().camera_sense_multiplier - 0.03) * 50.0)

func _on_quit_pressed():
	get_node("/root/World/").disconnect_from_server()
	self.queue_free()


func _on_settings_pressed():
	$Main.visible = false
	$Settings.visible = true


func _on_return_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_parent().pause_movement = false
	self.queue_free()


func _on_settings_return_pressed():
	$Main.visible = true
	$Settings.visible = false


func _on_sensitivity_value_changed(value):
	get_parent().change_sensitivity(value)
