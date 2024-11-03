extends KinematicBody2D

var tank_projectile = load("res://Tank_Projectile.tscn")#loads the tank projectile
var name_of_level = "Level1" #in player, this is modified by Level1 but since all duplicated scenes share the same script having this is redundant.

onready var parent = self.get_parent()

var Dict = {#SHOT COOLDOWN MUST NEVER BE LOWER THAN RECOVERY SPEED
	"pistol_shot_effect" : load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Effects/shotThin.png"),
	"pistol_sprite" : load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Projectiles/bulletBlue1_outline.png"),#This is the project ile
	"pistol_shot_speed":500,#Speed of the bullet is 500
	"pistol_shot_cooldown":1.5,#Cooldown before shots
	"pistol_recovery_speed":1,#how long it takes for turret to recover from each shot. Not always the same as cooldown!
	"pistol_shot_effect_offset":11.9,#Affects ONLY fire effect. changing this will change ONLY fire effect position and NOT bullet entry
	"pistol_shot_entry_position":25,#Affects BOTH fire effect and bullet entry position. changing this will change both fire effect and bullet entry
	"pistol_shot_size":Vector2(6,8),#Be careful of this one! Passing the direct value pair might not work!
	"pistol_damage":10,
	"pistol_above_player":true,
	"pistol_gun_sprite":load("res://Assets/topdown-shooter/PNG/Soldier 1/soldier1_gun.png"),
	
	
}





var turretList = ["pistol","sniper","machine_gun","missile_launcher"]
#var offsetList #Gets loaded with values from Player parent
export var currentTurretSprite = 0


var rotation_speed = 2.5
var will_rotate = "player_not_found"

var canTurn = true
var state = "ready"#state of turret cooldown
onready var player = get_node("/root/"+"Level1/"+"Player")
var final_angle
var rotation_angle_default = 270 #What angle does the turret default to if the player is not in range? This gets changed by the tank body parent

var right = 0
var left = 0
var calculation
func _ready():
	
	#currentTurretSprite = self.get_parent().currentTurretSprite
	$Entry.offset.y = Dict[turretList[currentTurretSprite]+"_shot_effect_offset"]#We might need ot change this
	$Entry.position.y = Dict[turretList[currentTurretSprite]+"_shot_entry_position"]
	$Sprite.texture = Dict[turretList[currentTurretSprite] + "_gun_sprite"]

	

func _physics_process(delta):
		
	
	#THIS IS THE CHUNK OF CODE THAT DOES THE TURRET TURNING
	#If we found player, the target angle is always the player's angle
	if canTurn == true:
		if will_rotate == "player_found":final_angle =  calculate_angle(global_position,player.global_position)
		#if we did not find the player, the target angle is the default resting angle. That default resting angle can be changed by the parent.
		elif will_rotate == "player_not_found":final_angle = rotation_angle_default
		
		
		if final_angle < rotation_degrees:
			calculation = (final_angle + 360) - rotation_degrees
			if calculation < 180:rotation_degrees+=rotation_speed
			elif calculation > 180:rotation_degrees-=rotation_speed
		elif final_angle > rotation_degrees:
			calculation = final_angle - rotation_degrees
			if calculation < 180: rotation_degrees+=rotation_speed
			elif calculation > 180:rotation_degrees-=rotation_speed
		
		
		
		
	if rotation_degrees < 0: rotation_degrees +=360
	else:rotation_degrees = fmod(rotation_degrees,360)#reset everything back to [0,360]
	
	
		
		
	match state:
			
		"ready":
			if $SightLine.is_colliding():
				fire_shot()
		"cooldown":
			pass

func fire_shot():
	if true:#We remove this if statement because ai will call the function directly.
		
		var temp_rotation = rotation_degrees
		if rotation_degrees < 0:rotation_degrees = 360 - fmod(abs(temp_rotation),360)
		else: rotation_degrees = fmod(temp_rotation,360)
		
		
		var paremX = -1 * sin(deg2rad(rotation_degrees)) * Dict[turretList[currentTurretSprite]+"_shot_speed"]
		var paremY = cos(deg2rad(rotation_degrees)) * Dict[turretList[currentTurretSprite]+"_shot_speed"] 
			
		var paremDict = {
			"bullet_scene":tank_projectile,
			"bullet_sprite": Dict[turretList[currentTurretSprite]+"_sprite"],
			"velX": paremX,
			"velY": paremY,
			"global_position":$Entry.get_global_position(),
			"bullet_rotation":rotation_degrees,
			"bullet_size_width":Dict[turretList[currentTurretSprite]+"_shot_size"][0],
			"bullet_size_height":Dict[turretList[currentTurretSprite]+"_shot_size"][1],
			"name":turretList[currentTurretSprite],
			"damage":Dict[turretList[currentTurretSprite]+"_damage"],
			"above_player":Dict[turretList[currentTurretSprite] +"_above_player"],
			"isEnemy":true#To notify the Level1 script that this is a bullet of the enemy.
		}
		var Level = get_node("/root/"+name_of_level)
		Level.summon_bullet(paremDict)#Add extra parameters for types of turrets.
		$Shot_Cooldown.wait_time = Dict[turretList[currentTurretSprite]+"_shot_cooldown"]
		$Shot_Cooldown.start()
		state = "cooldown"
		
		
		
		#Handles gun flash
		$Entry.texture = Dict[turretList[currentTurretSprite]+"_shot_effect"]#MIGHT HAVE TO CHANGE NULL TO BASE OFFSET VALUE
		$Entry.offset.y = Dict[turretList[currentTurretSprite]+"_shot_effect_offset"]#Performs the muzzle flash
		
		
		
		
		$Entry.visible = true #FOR DEBUGGING PURPOSES ONLY
		$Shot_Effect_Cooldown.start()
		
		


#NEEDS TO BE CONNECTED
func _on_Shot_Cooldown_timeout():
	state = "ready"

#NEEDS TO BE CONNECTED
func _on_Shot_Effect_Cooldown_timeout():
	$Entry.visible = false




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



	



#The player is "detected" and in range!

#THIS NEEDS TO BE CONNECTED
func _on_DetectionArea_body_entered(body):
	will_rotate = "player_found"

#THIS NEEDS TO BE CONNECTED
func _on_DetectionArea_body_exited(body):
	will_rotate = "player_not_found"



func addHealth(damage):
	parent.health+=damage
	parent.get_child(1)._on_health_updated(damage)
	if parent.health <=0:
		get_node("/root/"+name_of_level).checkCompletion()
		parent.queue_free()
