extends Control



func _process(delta):
	$Day.text = Global.get_day_name()
	$Inventory/Wheat.text = str(get_node("../Stats").crop_counts[Global.Plants.WHEAT]) +  "   "
	$Inventory/Corn.text = str(get_node("../Stats").crop_counts[Global.Plants.CORN]) + "   "
	$Inventory/Potatoes.text = str(get_node("../Stats").crop_counts[Global.Plants.POTATO]) + "   "
	$Inventory/Carrots.text = str(get_node("../Stats").crop_counts[Global.Plants.CARROT]) + "   "
	$Inventory/Mushrooms.text = str(get_node("../Stats").crop_counts[Global.Plants.MUSHROOM]) + "   "
	$Inventory/Money.text = str(get_node("../Stats").money) + "   "
	$Quota.text = "DUE: " + str(Global.quotaPrice + get_parent().addedQuota - get_node("../Stats").moneyPaid)
	#if get_parent().
	
	
