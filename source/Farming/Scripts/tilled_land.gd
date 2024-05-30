extends Node3D

var wheatplant = preload("res://Farming/plant_prototype.tscn")

var sound1 = preload("res://Sounds/dirt1.mp3")
var sound2 = preload("res://Sounds/dirt2.mp3")
var sound3 = preload("res://Sounds/dirt3.mp3")
var sound4 = preload("res://Sounds/dirt4.mp3")
	
@onready var audio = $AudioStreamPlayer3D

@export var water_level:float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var num = randi_range(0, 3)
	if num == 0:
		audio.set_stream(sound1)
	if num == 1:
		audio.set_stream(sound2)
	if num == 2:
		audio.set_stream(sound3)
	if num == 3:
		audio.set_stream(sound4)
		
	
	audio.play()

func reduce_water(delta):
	if water_level > delta:
		water_level = water_level - delta
		$CSGTorus3D.material.albedo_color = Color.from_hsv(31.0/255.0,((100.0-(water_level*30.0))/100.0),(43.0-(water_level*20))/100.0,1.0)

func grow(plant):
	if get_node_or_null("PLANT"): return
	gplant(plant)
	$/root/World/TilledLand.grow_plant.rpc(self.name,plant)

#H  S   V  A
#31 100 34 255

func gplant(plant):
	var growplant = get_node("/root/World/PlantSpawner").quick_init(plant)
	growplant.name = "PLANT"
	add_child(growplant)
	growplant.get_node("Plant/PlantBody/AnimationPlayer").play("Plant_Growth_anim")

func harvest_plant(plant):
	if !get_node_or_null("PLANT"): return
	$/root/World/TilledLand.harvest_plant.rpc(self.name)
	if get_node("PLANT/Plant/PlantBody/AnimationPlayer").current_animation_position == 1:
		get_node("/root/World/mpSpawned_" + str(multiplayer.get_unique_id())).get_node("Stats").crop_counts[plant] += get_node("PLANT").crop_yield
	harvest()
	
func harvest():
	get_node("PLANT").queue_free()
	
