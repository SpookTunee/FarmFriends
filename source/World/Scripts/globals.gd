extends Node

@export var day: int = 0
@export var dayfloat: float = 0.0
@export var players: Array = []

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


func get_day_name():
	return ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"][day%7]
