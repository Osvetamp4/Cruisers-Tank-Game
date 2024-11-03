extends KinematicBody2D

var speed = 50
var velocity = Vector2.ZERO
var path = []#This is where all the destinations on the object's route are stored.
var threshold = 16 #How far away can the  object be from a destination tolerate it?
var nav = null #This holds the navmap of our level 
var keep_distance = 100#Enemy_Body will always keep this distance away from player.
export var currentTurretSprite = 0

var health = 30
var max_health = 30

var state = "active"

func _ready():
	yield(owner,"ready")
	nav = owner.nav

func _physics_process(delta):
	#print("Angle default:"+str($Soldier_Turret.rotation_angle_default))
	#print("Actual angle: " + str(rotation_degrees))
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
		var direction = global_position.direction_to(path[0])#Gets direction from our position to point.
		velocity = direction * speed#Moves the entire body directly to that point
		$Soldier_Turret.rotation_angle_default = $Soldier_Turret.calculate_angle(Vector2(0,0),velocity)
		velocity = move_and_slide(velocity)#Now we move with a velocity in that direction



func get_target_path(target_pos):#Gets a list of 
	path = nav.get_simple_path(global_position,target_pos,false)#Godot's built in path finding algorithm creates a list of points in order to get from point a to b.
	

