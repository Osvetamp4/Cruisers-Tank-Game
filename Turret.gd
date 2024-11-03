extends Sprite
#test???????

var alt_shot = true #true is machine_barrel_1, false is machine_barrel_2

var tank_projectile = load("res://Tank_Projectile.tscn")#loads the tank projectile

var name_of_level

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
	
	
	
	"sniper_shot_effect" : load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Effects/shotRed.png"),
	"sniper_sprite" : load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Projectiles/bulletBlue1_outline.png"),
	"sniper_shot_speed":1000,#1000
	"sniper_shot_cooldown":2.5,
	"sniper_recovery_speed":1.5,
	"sniper_shot_effect_offset":20,#20
	"sniper_shot_entry_position":20,
	"sniper_shot_size":Vector2(7,4),#Be careful of this one! Passing the direct value pair might not work!
	"sniper_knockback":4,
	"sniper_turret_offset":9.3,
	"sniper_above_player":true,
	"sniper_damage":75,
	
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
	"machine_gun_shot_size": Vector2(4,9),
	"machine_gun_knockback":4,
	"machine_gun_turret_offset":-2.5,
	"machine_gun_turret_side_entry_position":8,
	"machine_gun_above_player":true,
	"machine_gun_damage":5,#5
	
	
	"missile_launcher_shot_effect" : load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Effects/shotThin.png"),
	"missile_launcher_sprite" : load("res://Assets/tower-defense-top-down/PNG/Default size/towerDefense_tile252.png"),
	"missile_launcher_shot_speed":2000, # 2000
	"missile_launcher_shot_cooldown":5,
	"missile_launcher_recovery_speed":0,
	"missile_launcher_shot_effect_offset":0,#11.9
	"missile_launcher_shot_entry_position":6.75,
	"missile_launcher_shot_size": Vector2(11.75,18.75),
	"missile_launcher_knockback":0,
	"missile_launcher_turret_offset":0,
	"missile_launcher_above_player":false,
	"missile_launcher_damage":25,
}



var turretList = ["default","sniper","machine_gun","missile_launcher"]
#var offsetList #Gets loaded with values from Player parent
var currentTurretSprite = 0




var state = "ready"#state of turret cooldown

func _ready():
	$Entry.offset.y = Dict["default_shot_effect_offset"]#We might need ot change this
	$Entry.position.y = Dict["default_shot_entry_position"]
	
	$Empty_Missile_Pad.flip_v = true
	$Empty_Missile_Pad.scale = Vector2(2,2)
	

func _physics_process(delta):
	
	look_at(Main.rotate_around_point(global_position,get_global_mouse_position(),-90))
	#We will need to change this look_at function later)
	match state:
		
		"ready":#This is where we put turret AI...right after we figure out where this shot management goes
			fire_shot()
		"cooldown":
			pass


func fire_shot():
	if Input.is_action_pressed("left_mouse"):#We remove this if statement because ai will call the function directly.
		
		if turretList[currentTurretSprite] == "machine_gun":
			if alt_shot == true:$Entry.position.x = Dict["machine_gun_turret_side_entry_position"]
			else:$Entry.position.x = -1 * Dict["machine_gun_turret_side_entry_position"]
		else:$Entry.position.x = 0
		
		
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
			"damage":Dict[turretList[currentTurretSprite]+"_damage"]
		}
		var Level = get_node("/root/"+name_of_level)
		Level.summon_bullet(paremDict)#Add extra parameters for types of turrets.
		$Shot_Cooldown.wait_time = Dict[turretList[currentTurretSprite]+"_shot_cooldown"]
		$Shot_Cooldown.start()
		state = "idle"
		
		#This handles the actual recoil of the turret, the pushback
		var tempOffset = offset.y
		offset.y = tempOffset-Dict[turretList[currentTurretSprite]+"_knockback"]#performs the knockback
		if alt_shot == true:$Barrel_Base/Machine_Barrel_1.offset.y = tempOffset-Dict[turretList[currentTurretSprite]+"_knockback"]
		else: $Barrel_Base/Machine_Barrel_2.offset.y = tempOffset-Dict[turretList[currentTurretSprite]+"_knockback"]
		
		$Tween.interpolate_property(self,"offset:y",null,tempOffset,Dict[turretList[currentTurretSprite]+"_recovery_speed"])#performs the recovery animation
		if alt_shot == true:$Tween.interpolate_property($Barrel_Base/Machine_Barrel_1,"offset:y",null,tempOffset,Dict[turretList[currentTurretSprite]+"_recovery_speed"])
		else: $Tween.interpolate_property($Barrel_Base/Machine_Barrel_2,"offset:y",null,tempOffset,Dict[turretList[currentTurretSprite]+"_recovery_speed"])
		#Handles gun flash
		$Entry.texture = Dict[turretList[currentTurretSprite]+"_shot_effect"]#MIGHT HAVE TO CHANGE NULL TO BASE OFFSET VALUE
		$Entry.offset.y = Dict[turretList[currentTurretSprite]+"_shot_effect_offset"]#Performs the muzzle flash
		
		
		
		
		$Tween.start()
		$Entry.visible = true #FOR DEBUGGING PURPOSES ONLY
		$Shot_Effect_Cooldown.start()
		
		alt_shot = !alt_shot
		
		if turretList[currentTurretSprite] == "missile_launcher":
			$Empty_Missile_Pad.visible = true
			self.scale = Vector2(0.45,0.45)


func _on_Shot_Cooldown_timeout():
	state = "ready"
	if $Empty_Missile_Pad.visible == true:
		$Empty_Missile_Pad.visible = false
		self.scale = Vector2(0.9,0.9)



func _on_Turret_texture_changed():
	
	currentTurretSprite+=1
	currentTurretSprite=fmod(currentTurretSprite,len(turretList))
	print(turretList[currentTurretSprite])
	if turretList[currentTurretSprite] == "machine_gun": $Barrel_Base.visible = true
	else: $Barrel_Base.visible = false
		
	offset.y = Dict[turretList[currentTurretSprite]+"_turret_offset"]
	$Barrel_Base/Machine_Barrel_1.offset.y = Dict[turretList[currentTurretSprite]+"_turret_offset"]
	$Barrel_Base/Machine_Barrel_2.offset.y = Dict[turretList[currentTurretSprite]+"_turret_offset"]
	$Entry.position.y = Dict[turretList[currentTurretSprite]+"_shot_entry_position"]
	#Might need to optimize
	
	
	


func _on_Shot_Effect_Cooldown_timeout():
	$Entry.visible = false
	#$Entry.offset.y = 0
	#$Barrel_Base/Machine_Barrel_1.offset.y = 0
	#$Barrel_Base/Machine_Barrel_2.offset.y = 0
	
	
