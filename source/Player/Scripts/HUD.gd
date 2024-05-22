extends Control

var ticks: int = 0
var tpos: int =  0
var ovrrd: int = -1

func _process(delta):
	ticks += 1
	$Day.text = Global.get_day_name()
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

func switch_hotbar_slot(slot : int, slot2 : int):
	if slot == 0:
		for x in range($Hotbar/Tools.get_children().size()):
			if x == slot2:
				$Hotbar/Tools.get_child(x).show()
			else:
				$Hotbar/Tools.get_child(x).hide()
	if slot == 1:
		for x in range($Hotbar/Seeds.get_children().size()):
			if x == slot2:
				$Hotbar/Seeds.get_child(x).show()
			else:
				$Hotbar/Seeds.get_child(x).hide()
	if slot == 2:
		for x in range($Hotbar/Misc.get_children().size()):
			if x == slot2:
				$Hotbar/Misc.get_child(x).show()
			else:
				$Hotbar/Misc.get_child(x).hide()
	
