extends Control



func _on_tools_pressed():
	$HBoxContainer/Categories.visible = false
	$HBoxContainer/Tools.visible = true


func _on_seeds_pressed():
	pass # Replace with function body.


func _on_signs_pressed():
	pass # Replace with function body.


func _on_structures_pressed():
	pass # Replace with function body.


func _on_close_bar_pressed():
	for i in $HBoxContainer.get_children():
		i.visible = false
	$HBoxContainer/Categories.visible = true
	$HBoxContainer/CloseBar.visible = true
