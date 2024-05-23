extends Node3D
var player = get_parent().get_parent().get_parent()

var stat = preload("res://Tools/boot_stats.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func activate():
	var statload = stat.instantiate()
	var check = player.get_node_or_null("bootStats")
	if check == null:
		player.add_child(statload)
	else:
		player.remove_child(statload)
