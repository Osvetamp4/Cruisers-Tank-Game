extends KinematicBody2D

export var type = "default"#Can be sniper/machine gun, changed by level1 node
var velocity = Vector2()#This can also be changed by parent level1 node
var state = "bullet"#Can be changed to missile, changed by level1 node
var damage = 0#This gets changed by Level1 node
var futureVelocity = Vector2()
var incrementation = 0.001



var one_shot_bool = true
func _ready():
	#print(futureVelocity)
	pass

func _physics_process(delta):
	match state:
		"bullet":
			velocity = move_and_slide(velocity)
		"missile":
			velocity = move_and_slide(velocity)
			if one_shot_bool == true:
				$Missile_Timer.start()
				#print("this should only print once per shot")
				one_shot_bool = false
		"missile_part_2":
			velocity = move_and_slide(velocity)
			#print("MISSILE PART TWO ACTIVE")
			velocity.x = lerp(velocity.x,futureVelocity.x,incrementation)
			velocity.y = lerp(velocity.y,futureVelocity.y,incrementation)
			#print(velocity)
			incrementation *= 1.1


func _on_Area2D_body_entered(body):#We will use this to register hits
	print("amogus")
	
	if state == "missile_part_2":#only apply the explosion effect if the missile is in second stage.
		var explosion_instance = load("res://Explosion.tscn").instance()
		add_child(explosion_instance)
	body.addHealth(-1 * damage)#apply the direct impact damage regardless of state.
	if state != "missile_part_2":queue_free()


func _on_Missile_Timer_timeout():
	state = "missile_part_2"
#LAYER 2:TRUE
#MASK 3:TRUE, 4:TRUE





