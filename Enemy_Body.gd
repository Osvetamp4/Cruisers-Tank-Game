extends KinematicBody2D
onready var player = get_node("/root/"+"Level1/"+"Player")

var speed = 100
var velocity = Vector2.ZERO
var path = []#This is where all the destinations on the object's route are stored.
var threshold = 16 #How far away can the  object be from a destination tolerate it?
var nav = null #This holds the navmap of our level 
var keep_distance = 132#Enemy_Body will always keep this distance away from player.
var rotation_speed = 2.5
export var currentTurretSprite = 0

var health = 100
var max_health = 100

var state = "active"


func _ready():
	
	yield(owner,"ready")
	nav = owner.nav
	if currentTurretSprite == 1:keep_distance = 800
#NEED TO PROGRAM DIRECTIONAL MOVEMENT, COPY FROM PLAYER'S TANK BODY
func _physics_process(delta):
	
	match state:
		"active":
			if path.size() > 0:
				if global_position.distance_to(get_tree().get_nodes_in_group("Player")[0].global_position) <= keep_distance:pass
				else:move_to_target()
		"idle":pass
		
	

func move_to_target():#Moves us from where we are to the next point in our path in a straight line.
	
	if global_position.distance_to(path[0]) < threshold:#if the next point on our path is smaller than our threshold distance, we remove it. it's close enough that we're "already there"
		path.remove(0)#move onto the next point for calculation
		
	else:
		var final_angle = calculate_angle(global_position,path[0])
		#HANDLES ROTAITON TO ANGLE FOR ENEMY BODY
		if abs(final_angle - $CollisionShape2D.rotation_degrees) >= rotation_speed:rotate_to(final_angle)
		
		
		if $CollisionShape2D.rotation_degrees < 0: 
			$CollisionShape2D.rotation_degrees +=360
			$Enemy_Base.rotation_degrees +=360
		else:
			$CollisionShape2D.rotation_degrees = fmod($CollisionShape2D.rotation_degrees,360)#reset everything back to [0,360]
			$Enemy_Base.rotation_degrees = fmod($Enemy_Base.rotation_degrees,360)
		
		
		#$CollisionShape2D.rotation_degrees = final_angle
		#$Enemy_Base.rotation_degrees = final_angle
		#rotation_degrees = int(round(rotation_degrees))
		#NEXT THREE LINES HANDLE DIRECTION MOVEMENT(maybe we need to install a yield function)
		if abs($CollisionShape2D.rotation_degrees - final_angle) <= rotation_speed:
			
			velocity.x = -1 * sin(deg2rad($CollisionShape2D.rotation_degrees)) * speed
			velocity.y = cos(deg2rad($CollisionShape2D.rotation_degrees)) * speed
			velocity = move_and_slide(velocity)
#		if abs(rotation_degrees - final_angle) <= rotation_speed:
#			var direction = global_position.direction_to(path[0])#Gets direction from our position to point.
#			velocity = direction * speed#Moves the entire body directly to that point
#			velocity = move_and_slide(velocity)#Now we move with a velocity in that direction


func get_target_path(target_pos):#Gets a list of 
	path = nav.get_simple_path(global_position,target_pos,false)#Godot's built in path finding algorithm creates a list of points in order to get from point a to b.



func calculate_angle(enemy,player):#Vector2() parameters, takes in enemy coordinates and player coordinates and calculates angle enemy turret should face player.
	var quadrant
	#if in quandrant 1
	if enemy[0] <= player[0] and enemy[1] >= player[1]:quadrant = 1
	elif enemy[0] <= player[0] and enemy[1] <= player[1]:quadrant = 4
	elif enemy[0] >= player[0] and enemy[1] >= player[1]:quadrant = 2
	elif enemy[0] >= player[0] and enemy[1] <= player[1]:quadrant = 3
	var xLength = abs(enemy[0] - player[0])
	var yLength = abs(enemy[1] - player[1])
	if xLength == 0:
		if player[1] < enemy[1]:return 180#case for if player is right above target.
		elif player[1] >= enemy[1]:return 0
	var angle = rad2deg(atan(yLength/xLength))
	
	
	if quadrant == 1: angle=(270-angle)
	elif quadrant == 2: angle+=90
	elif quadrant == 3: angle = 90-angle
	elif quadrant == 4: angle+=270
	
	return angle


func rotate_to(final_angle):#must be called every frame for optimal performance
	if final_angle < $CollisionShape2D.rotation_degrees:
		var calculation = (final_angle + 360) - $CollisionShape2D.rotation_degrees
		if calculation < 180:
			$CollisionShape2D.rotation_degrees+=rotation_speed
			$Enemy_Base.rotation_degrees+=rotation_speed
		elif calculation > 180:
			$CollisionShape2D.rotation_degrees-=rotation_speed
			$Enemy_Base.rotation_degrees-=rotation_speed
	elif final_angle > rotation_degrees:
		var calculation = final_angle - $CollisionShape2D.rotation_degrees
		if calculation < 180: 
			$CollisionShape2D.rotation_degrees+=rotation_speed
			$Enemy_Base.rotation_degrees+=rotation_speed
		elif calculation > 180: 
			$CollisionShape2D.rotation_degrees-=rotation_speed
			$Enemy_Base.rotation_degrees-=rotation_speed
	$Enemy_Turret.rotation_angle_default = $CollisionShape2D.rotation_degrees


func addHealth(damage):
	health+=damage
	$HealthBar._on_health_updated(damage)
	if health <=0:
		get_node("/root/"+$Enemy_Turret.name_of_level).checkCompletion()
		queue_free()
