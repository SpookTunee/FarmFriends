extends Node

var day : int
var dayName : String

enum Regions {
	NONE,
	PLAINS,
	MOUNTAINOUS,
	RIVER,
	FOREST,
}
enum Plants {
	WHEAT,
	CORN,
	POTATO,
	CARROT,
	MUSHROOM,
}

func _process(delta):
	dayCalc()


func dayCalc():
	var weekday = day % 7
	
	if weekday == 0:
		dayName = "Sunday"
	if weekday == 1:
		dayName = "Monday"
	if weekday == 2:
		dayName = "Tuesday"
	if weekday == 3:
		dayName = "Wednesday"
	if weekday == 4:
		dayName = "Thursday"
	if weekday == 5:
		dayName = "Friday"
	if weekday == 6:
		dayName = "Saturday"
