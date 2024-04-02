extends Control


func _on_quit_pressed():
	get_node("/root/World/").disconnect_from_server()
	self.queue_free()


func _on_settings_pressed():
	$Main.visible = false
	$Settings.visible = true


func _on_return_pressed():
	self.queue_free()


func _on_settings_return_pressed():
	$Main.visible = true
	$Settings.visible = false


func _on_sensitivity_value_changed(value):
	get_parent().change_sensitivity(value)
