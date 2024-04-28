extends Control



func _process(delta):
	$Day.text = Global.get_day_name()
	$Inventory/Wheat.text = str(get_node("../Stats").crop_counts[Global.Plants.WHEAT]) + " Wheat"
	$Inventory/Corn.text = str(get_node("../Stats").crop_counts[Global.Plants.CORN]) + " Corn"
	$Inventory/Potatoes.text = str(get_node("../Stats").crop_counts[Global.Plants.POTATO]) + " Potatoes"
	$Inventory/Carrots.text = str(get_node("../Stats").crop_counts[Global.Plants.CARROT]) + " Carrots"
	$Inventory/Mushrooms.text = str(get_node("../Stats").crop_counts[Global.Plants.MUSHROOM]) + " Mushrooms"
	$Inventory/Money.text = "$" + str(get_node("../Stats").money)
	$Quota.text = "DUE: " + str(Global.quotaPrice - get_node("../Stats").moneyPaid)
