extends Node

@export var day: int = 0
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