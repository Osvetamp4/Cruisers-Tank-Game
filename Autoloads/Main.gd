extends Node2D






func _ready():
	pass
	
#precondition: global_origin and global_rotate_point are Vector2.
func rotate_around_point(global_origin,global_rotate_point,angle):
	var tempX = global_rotate_point[0] - global_origin[0]
	var tempY = global_rotate_point[1] - global_origin[1]
	var temperX = tempX
	var temperY = tempY
	tempX = temperX * cos(deg2rad(angle))- temperY * sin(deg2rad(angle))
	tempY = temperY * cos(deg2rad(angle)) + temperX * sin(deg2rad(angle))
	tempX+=global_origin[0]
	tempY+=global_origin[1]
	var newCoords = Vector2(tempX,tempY)
	return newCoords

#bullet_scene = load the Tank_Projectile scene, bullet_sprite = load the specific sprite, velX/velY is the individual velocities respectively, global_position = global position of the turret, bullet_rotation = rotation of turret which is the rotation that the bullet requires
func summon_bullet(infoDict):
	var bullet_instance = infoDict["bullet_scene"].instance()
	
	bullet_instance.get_node("Sprite").texture = infoDict["bullet_sprite"]
	bullet_instance.velocity.x = infoDict["velX"]
	bullet_instance.velocity.y = infoDict["velY"]
	if infoDict["name"] == "missile_launcher":
		bullet_instance.scale = Vector2(0.9,0.9)
		bullet_instance.state = "missile"
		bullet_instance.futureVelocity.x = infoDict["velX"]
		bullet_instance.futureVelocity.y = infoDict["velY"]
		bullet_instance.velocity.x = infoDict["velX"] * 0.025#for the time being it stays 0
		bullet_instance.velocity.y = infoDict["velY"] * 0.025
	bullet_instance.position = infoDict["global_position"]
	bullet_instance.rotation_degrees = infoDict["bullet_rotation"]
	bullet_instance.get_node("Tank_Area2D").bullet_size = Vector2(infoDict["bullet_size_width"],infoDict["bullet_size_height"])#infoDict["bullet_size"]
	add_child(bullet_instance)
