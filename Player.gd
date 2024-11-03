extends KinematicBody2D
#Green, Sand, Red, blue, Black, V Black, Huge Black, gigantic Red
#Default, Gasser, Sniper
#Machine guns, Mildy Thick, It's in the middle, Muzzler
var velocity = Vector2()
var state = "movement"
var friction = 0.2
var speed = 100
var currentPlayerTurret = 0
var max_health = 999
var health = 999

var default = load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Barrels/specialBarrel1_outline.png")
#var gasser = load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Barrels/specialBarrel2_outline.png")
var sniper = load("res://Assets/kenney_topdowntanksredux/PNG/Default size/Tank Barrels/specialBarrel3_outline.png")
var machine_gun = load("res://Machine_Gun.tscn")
var missile_launcher = load("res://Assets/tower-defense-top-down/PNG/Default size/towerDefense_tile206.png")
var turretList = [default,sniper,machine_gun,missile_launcher]
#var turretOffsetList = [4.4,5,9.3,-2.5]
#var bulletEntryList = [16.35,18.5,20,17.5]#16.35

func _draw():
	draw_line(Vector2(0,0), Vector2(0, 0), Color(255, 0, 0), 1)

func _ready():
	#$Turret.offsetList = turretOffsetList
	changeTurretSpriteAndOffset(true)
	rotation_degrees+=360
	

func _physics_process(delta):
	changeTurretSpriteAndOffset()
	
	match state:
		"movement":
			movement()
		"idle":
			pass



func changeTurretSpriteAndOffset(firstVar = false):#Changing the turret texture is how Player script communicates with Turret Script
	if Input.is_action_just_pressed("e") and firstVar == false and $Turret.state == "ready":
		currentPlayerTurret+=1
		currentPlayerTurret = fmod(currentPlayerTurret,len(turretList))
		$Turret.texture = turretList[currentPlayerTurret]
		
		
		if $Turret.texture == missile_launcher:
			$Turret.flip_v = true
			$Turret.scale = Vector2(0.9,0.9)
			#$Turret.scale = Vector2(1,1)
		else: 
			$Turret.flip_v = false
			$Turret.scale = Vector2(1.5,1.5)
		#$Turret.offset.y = turretOffsetList[currentPlayerTurret]
		#$Turret/Barrel_Base.offset.y = turretOffsetList[currentPlayerTurret]#Might have to optimize the offset changing for machine_gun when it is invisible
		#$Turret/Barrel_Base/Machine_Barrel_1.offset.y = turretOffsetList[currentPlayerTurret]
		#$Turret/Barrel_Base/Machine_Barrel_2.offset.y = turretOffsetList[currentPlayerTurret]
		
		#$Turret/Entry.position.y = bulletEntryList[currentPlayerTurret]
	if firstVar == true:
		$Turret.texture = turretList[currentPlayerTurret]
		#$Turret.offset.y = turretOffsetList[currentPlayerTurret]
		#$Turret/Entry.position.y = bulletEntryList[currentPlayerTurret]



func movement():#handles the movement
	var temp_rotation = $Base.rotation_degrees
	if $Base.rotation_degrees < 0:$Base.rotation_degrees = 360 - fmod(abs(temp_rotation),360)
	else: $Base.rotation_degrees = fmod(temp_rotation,360)
	#calculates rotation
	
	var tempVelocityX = velocity.x
	var tempVelocityY = velocity.y
	
	
	if Input.is_action_pressed("w"):
		
		velocity.x = -1 * sin(deg2rad($Base.rotation_degrees)) * speed
		velocity.y = cos(deg2rad($Base.rotation_degrees)) * speed
		
	elif Input.is_action_pressed("s"):
		velocity.x = sin(deg2rad($Base.rotation_degrees)) * speed
		velocity.y = -1 * cos(deg2rad($Base.rotation_degrees)) * speed
		
		
	velocity = move_and_slide(velocity)
	velocity.x = lerp(velocity.x,0,friction)
	velocity.y = lerp(velocity.y,0,friction)


func addHealth(damage):
	health+=damage
	$HealthBar._on_health_updated(damage)
	if health <=0:
		get_tree().change_scene("res://Game_Over.tscn")
		queue_free()


