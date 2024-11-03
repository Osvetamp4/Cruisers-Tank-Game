extends Sprite
var rotation_speed = 2.5
var state = "moving"
func _ready():
	pass

func _physics_process(delta):
	match state:
		"moving":
			rotation()
		"idle":
			pass
func rotation():
	if Input.is_action_pressed("a"):
		rotation_degrees-=rotation_speed
		for i in get_tree().get_nodes_in_group("playerCollisions"):
			i.rotation_degrees-=rotation_speed
	elif Input.is_action_pressed("d"):
		rotation_degrees+=rotation_speed
		for i in get_tree().get_nodes_in_group("playerCollisions"):
			i.rotation_degrees+=rotation_speed
	#print(rotation_degrees)
