extends Node3D

signal host
signal join

func hideme():
	visible = false
	$Control.visible = false

func _on_host_pressed():
	emit_signal("host")


func _on_join_pressed():
	emit_signal("join")


func _on_quit_pressed():
	get_tree().quit()
