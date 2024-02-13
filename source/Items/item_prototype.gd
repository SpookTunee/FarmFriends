extends RigidBody3D

var dropped = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if dropped == true:
		self.apply_impulse(transform.basis.z, -transform.basis.z *10)
		dropped = false
