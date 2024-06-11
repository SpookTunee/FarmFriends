extends Node3D

signal host
signal join

func hideme():
	visible = false
	$Control.visible = false

func lobbyactivate():
	$Control/VBoxContainer.visible = false
	$Control/VBoxContainer2.visible = true

func showme():
	visible = true
	$Control.visible = true

func _on_host_pressed():
	emit_signal("host")


func _on_join_pressed():
	emit_signal("join")


func _on_quit_pressed():
	get_tree().quit()


func _on_line_edit_text_changed(new_text):
	pass # Replace with function body.
