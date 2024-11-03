extends Sprite


var tank_projectile = load("res://Tank_Projectile.tscn")#loads the tank projectile
export var name_of_level = "Level1"#in player, this is modified by Level1 but since all duplicated scenes share the same script having this is redundant.

var Dict = {#SHOT COOLDOWN MUST NEVER BE LOWER THAN RECOVERY SPEED
	"default_shot_effect" : load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Effects/shotLarge.png"),
	"default_sprite" : load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Projectiles/bulletBlue2_outline.png"),
	"default_shot_speed":500,#Speed of the bullet is 500
	"default_shot_cooldown":1.5,#Cooldown before shots
	"default_recovery_speed":1,#how long it takes for turret to recover from each shot. Not always the same as cooldown!
	"default_shot_effect_offset":11.9,#Affects ONLY fire effect. changing this will change ONLY fire effect position and NOT bullet entry
	"default_shot_entry_position":16.35,#Affects BOTH fire effect and bullet entry position. changing this will change both fire effect and bullet entry
	"default_shot_size":Vector2(8,6),#Be careful of this one! Passing the direct value pair might not work!
	"default_knockback":4,#Knockback value
	"default_turret_offset":4.4,#Offset of the main turret head
	"default_above_player":true,
	"default_damage":25,
	"default_gun_sprite":load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Barrels/specialBarrel1_outline.png"),
	
	
	
	"sniper_shot_effect" : load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Effects/shotRed.png"),
	"sniper_sprite" : load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Projectiles/bulletBlue1_outline.png"),
	"sniper_shot_speed":1250,#1000
	"sniper_shot_cooldown":2.5,
	"sniper_recovery_speed":1.5,
	"sniper_shot_effect_offset":20,#20
	"sniper_shot_entry_position":20,
	"sniper_shot_size":Vector2(7,4),#Be careful of this one! Passing the direct value pair might not work!
	"sniper_knockback":4,
	"sniper_turret_offset":9.3,
	"sniper_above_player":true,
	"sniper_damage":150,
	"sniper_gun_sprite":load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Barrels/specialBarrel3_outline.png"),
	
	"gasser_shot_effect" : load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Effects/shotRed.png"),
	"gasser_sprite" : load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Projectiles/bulletBlue1_outline.png"),
	"gasser_shot_speed":250,#250
	"gasser_shot_cooldown":0.15,
	"gasser_recovery_speed":0,
	"gasser_shot_effect_offset":20,#20
	"gasser_shot_entry_position":20,
	"gasser_shot_size":Vector2(7,4),#Be careful of this one! Passing the direct value pair might not work!
	"gasser_knockback":0,
	"gasser_turret_offset":5,
	"gasser_above_player":true,
	"gasser_damage":0,
	
	"machine_gun_shot_effect" : load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Effects/shotThin.png"),
	"machine_gun_sprite" : load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Projectiles/bulletBlue3_outline.png"),
	"machine_gun_shot_speed":750, # 750
	"machine_gun_shot_cooldown":0.25,
	"machine_gun_recovery_speed":0.20,
	"machine_gun_shot_effect_offset":9,#11.9
	"machine_gun_shot_entry_position":17.5,
	"machine_gun_shot_size": Vector2(9,4),
	"machine_gun_knockback":4,
	"machine_gun_turret_offset":-2.5,
	"machine_gun_turret_side_entry_position":8,
	"machine_gun_above_player":true,
	"machine_gun_damage":5,
	
	
	"missile_launcher_shot_effect" : load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Effects/shotThin.png"),
	"missile_launcher_sprite" : load("res://Assets/tower-defense-top-down/PNG/Default size/towerDefense_tile252.png"),
	"missile_launcher_shot_speed":2000, # 2000
	"missile_launcher_shot_cooldown":5,
	"missile_launcher_recovery_speed":0,
	"missile_launcher_shot_effect_offset":0,#11.9
	"missile_launcher_shot_entry_position":6.75,
	"missile_launcher_shot_size": Vector2(18.75,11.75),
	"missile_launcher_knockback":0,
	"missile_launcher_turret_offset":0,
	"missile_launcher_above_player":false,
	"missile_launcher_damage":25,
}


var turretList = ["default","sniper","mortar"]
#var offsetList #Gets loaded with values from Player parent
var currentTurretSprite = 0


var rotation_speed = 2.5
var will_rotate = "player_not_found"

var canTurn = true
var state = "ready"#state of turret cooldown
onready var player = get_node("/root/"+name_of_level+"/"+"Player")
onready var level = get_node("/root/" + name_of_level)
var final_angle
var rotation_angle_default = 0 #What angle does the turret default to if the player is not in range? This gets changed by the tank body parent

var right = 0
var left = 0
var calculation
func _ready():
	
	currentTurretSprite = self.get_parent().currentTurretSprite
	offset.y = Dict[turretList[currentTurretSprite]+"_turret_offset"]
	$Entry.offset.y = Dict[turretList[currentTurretSprite]+"_shot_effect_offset"]#We might need ot change this
	$Entry.position.y = Dict[turretList[currentTurretSprite]+"_shot_entry_position"]
	self.texture = Dict[turretList[currentTurretSprite] + "_gun_sprite"]
	if turretList[currentTurretSprite] == "sniper":
		$SightLine.cast_to *=3
		$DetectionArea/CollisionShape2D.scale *=3 
	

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
			elif calculation > 180: rotation_degrees-=rotation_speed
		elif final_angle > rotation_degrees:
			calculation = final_angle - rotation_degrees
			if calculation < 180: rotation_degrees+=rotation_speed
			elif calculation > 180: rotation_degrees-=rotation_speed
		
		
		
		
	if rotation_degrees < 0: rotation_degrees +=360
	else:rotation_degrees = fmod(rotation_degrees,360)#reset everything back to [0,360]
		
		
		
	match state:
			
		"ready":
			if $SightLine.is_colliding():
				if turretList[currentTurretSprite] == "sniper":
					state = "cooldown"
					canTurn = false
					self.get_parent().state = "idle"
					$Shot_Delay.start()
					#level.laserDraw(global_position,player.global_position)
					#self.get_parent().stop = true
					#stop = true
				else:fire_shot()
			
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
			"above_player":Dict[turretList[currentTurretSprite]+"_above_player"],
			"damage":Dict[turretList[currentTurretSprite]+"_damage"],
			"isEnemy":true#To notify the Level1 script that this is a bullet of the enemy.
		}
		var Level = get_node("/root/"+name_of_level)
		Level.summon_bullet(paremDict)#Add extra parameters for types of turrets.
		$Shot_Cooldown.wait_time = Dict[turretList[currentTurretSprite]+"_shot_cooldown"]
		$Shot_Cooldown.start()
		state = "cooldown"
		
		#This handles the actual recoil of the turret, the pushback
		var tempOffset = offset.y
		offset.y = tempOffset-Dict[turretList[currentTurretSprite]+"_knockback"]#performs the knockback
		
		$Tween.interpolate_property(self,"offset:y",null,tempOffset,Dict[turretList[currentTurretSprite]+"_recovery_speed"])#performs the recovery animation
		#Handles gun flash
		$Entry.texture = Dict[turretList[currentTurretSprite]+"_shot_effect"]#MIGHT HAVE TO CHANGE NULL TO BASE OFFSET VALUE
		$Entry.offset.y = Dict[turretList[currentTurretSprite]+"_shot_effect_offset"]#Performs the muzzle flash
		
		
		
		
		$Tween.start()
		$Entry.visible = true #FOR DEBUGGING PURPOSES ONLY
		$Shot_Effect_Cooldown.start()
		
		
		



func _on_Shot_Cooldown_timeout():
	state = "ready"


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


func _on_DetectionArea_body_entered(body):
	will_rotate = "player_found"


func _on_DetectionArea_body_exited(body):
	will_rotate = "player_not_found"


func _on_Shot_Delay_timeout():
	#level.laserDraw(global_position,global_position)
	fire_shot()
	$Shot_Delay2.start()





func _on_Shot_Delay2_timeout():
	canTurn = true
	self.get_parent().state = "active"
