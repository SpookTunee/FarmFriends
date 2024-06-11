extends Node3D

signal host
signal join
@export var name1:String = ""
@export var name2:String = ""
@export var name3:String = ""
@export var name4:String = ""
@export var ishost:bool
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
	ishost = true
	emit_signal("host")


func _on_join_pressed():
	ishost = false
	emit_signal("join")


func _on_quit_pressed():
	get_tree().quit()

	
@rpc
func nameadd(name11:String, name22:String, name33:String, name44:String):
	if name1 != name11:
		name1 = name11
		#$Control/VBoxContainer3.add_child()
	

func _on_line_edit_text_submitted(new_text):
	$Control/VBoxContainer2.hide()
	$Control/VBoxContainer3.show()
	if host:
		$Control/VBoxContainer3/Button.show()
	nameadd.rpc(new_text)


func _on_button_pressed():
	pass # Replace with function body.
