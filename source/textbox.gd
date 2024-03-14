@tool
extends Control

@export var text : String

# Called when the node enters the scene tree for the first time.
func _ready():
	$textbox.get_child(0).Text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
