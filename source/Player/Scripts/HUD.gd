extends Control

var ticks: int = 0
var tpos: int =  0
var ovrrd: int = -1

func _process(delta):
	ticks += 1
	$Day.text = Global.get_day_name()
	if get_parent().item_state["current"]["slot"] == "seeds":
		$Hotbar/Seeds/Control/SeedCount/Label.text = str(get_parent().item_state[get_parent().item_state["current"]["slot"]][get_parent().item_state["current"]["id"]]["count"]) + " seeds"
	if get_parent().item_state["current"]["id"] == "mine":
		$Hotbar/Misc/Control/MineCount/Label.text = str(get_parent().item_state["misc"]["mine"]["count"]) + " mines"
	else:
		$Hotbar/Misc/Control/MineCount/Label.text = ""
	$Inventory/Wheat.text = str(get_node("../Stats").crop_counts[Global.Plants.WHEAT]) +  "   "
	$Inventory/Corn.text = str(get_node("../Stats").crop_counts[Global.Plants.CORN]) + "   "
	$Inventory/Potatoes.text = str(get_node("../Stats").crop_counts[Global.Plants.POTATO]) + "   "
	$Inventory/Carrots.text = str(get_node("../Stats").crop_counts[Global.Plants.CARROT]) + "   "
	$Inventory/Mushrooms.text = str(get_node("../Stats").crop_counts[Global.Plants.MUSHROOM]) + "   "
	$Inventory/Money.text = str(get_node("../Stats").money) + "   "
	$Quota.text = "DUE: " + str(Global.quotaPrice + get_parent().addedQuota - get_node("../Stats").moneyPaid)
	if (tpos + (200 if ovrrd == -1 else ovrrd)) - ticks < 0:
		$Messages/RichTextLabel.text = ""
		ovrrd = -1
	
func send_unique_chat(msg: String, cooldown_override: int = -1):
	if ovrrd == -1:
		tpos = ticks
	ovrrd = cooldown_override
	$Messages/RichTextLabel.text += msg + "\n"

func switch_hotbar_slot(slot: int, id: String):
	if slot == 0:
		get_node("Hotbar/Tools/Control/Sprite2D").texture = load("Assets/Icons/" + id + "icon.png")
	elif slot == 1:
		get_node("Hotbar/Seeds/Control/Sprite2D").texture = load("Assets/Icons/" + id + "icon.png")
	elif slot == 2:
		get_node("Hotbar/Misc/Control/Sprite2D").texture = load("Assets/Icons/" + id + "icon.png")
	
