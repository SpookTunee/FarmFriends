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

func purchase(slot,id,cost,ismine=false):
	if get_parent().item_state[slot][id]["isunlocked"] == false:
		if get_node("../Stats").money >= cost:
			get_node("../Stats").money -= cost
			get_parent().item_state[slot][id]["isunlocked"] = true
			get_node("../HUD").send_unique_chat("[color=green]Purchased " + id + "[/color]")
		else:
			get_node("../HUD").send_unique_chat("[color=red]Not enough fundage[/color]")
	elif ismine:
		if get_node("../Stats").money >= cost:
			get_node("../Stats").money -= cost
			get_parent().item_state[slot][id]["count"] += 1
			get_node("../HUD").send_unique_chat("[color=green]Purchased 1x " + id + "[/color]")
		else:
			get_node("../HUD").send_unique_chat("[color=red]Not enough fundage[/color]")

func _on_shovel_pressed():
	purchase("misc","shovel",650)
