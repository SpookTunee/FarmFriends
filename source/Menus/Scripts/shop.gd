extends Control
var whp: bool = false
var cop: bool = false
var pop: bool = false
var cap: bool = false


func _on_tools_pressed():
	$HBoxContainer/Categories.visible = false
	$HBoxContainer/Tools.visible = true


func _on_seeds_pressed():
	$HBoxContainer/Categories.visible = false
	$HBoxContainer/Seeds.visible = true


func _on_signs_pressed():
	pass # Replace with function body.


func _on_misc_pressed():
	$HBoxContainer/Categories.visible = false
	$HBoxContainer/Misc.visible = true

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
	if ismine:
		if get_node("../Stats").money >= cost:
			get_node("../Stats").money -= cost
			get_parent().item_state[slot][id]["count"] += 1
			get_node("../HUD").send_unique_chat("[color=green]Purchased 1x " + id + "[/color]")
		else:
			get_node("../HUD").send_unique_chat("[color=red]Not enough fundage[/color]")

func _on_shovel_pressed():
	purchase("misc","shovel",150)


func _on_fast_hoe_pressed():
	if !get_parent().has_fast_hoe:
		if get_node("../Stats").money >= 250:
			get_node("../Stats").money -= 250
			get_parent().has_fast_hoe = true
			get_node("../HUD").send_unique_chat("[color=green]Purchased 1x fast_hoe[/color]")
		else:
			get_node("../HUD").send_unique_chat("[color=red]Not enough fundage[/color]")


func _on_boots_pressed():
	if !get_parent().has_boots:
		if get_node("../Stats").money >= 500:
			get_node("../Stats").money -= 500
			get_parent().has_boots = true
			get_parent().NORMAL_SPEED = 6.5
			get_parent().SPRINT_SPEED = 9.5
			get_parent().JUMP_VELOCITY = 10.0
			get_node("../HUD").send_unique_chat("[color=green]Purchased 1x boots[/color]")
		else:
			get_node("../HUD").send_unique_chat("[color=red]Not enough fundage[/color]")


func _on_landmine_pressed():
	purchase("misc","mine",80,true)

#1 .75 3 4

func _physics_process(_delta):
	if whp:
		purchase("seeds","wheat",1,true)
	elif cop:
		purchase("seeds","corn",0.75,true)
	elif pop:
		purchase("seeds","potato",3,true)
	elif cap:
		purchase("seeds","carrot",4,true)

func _on_wheat_pressed():
	whp = true

func _on_corn_pressed():
	cop = true

func _on_potato_pressed():
	pop = true

func _on_carrot_pressed():
	cap = true


func _on_wheat_button_up():
	whp = false


func _on_corn_button_up():
	cop = false


func _on_potato_button_up():
	pop = false


func _on_carrot_button_up():
	cap = false
