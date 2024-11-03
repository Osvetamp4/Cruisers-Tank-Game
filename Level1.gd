extends Node2D
export var levelID = "Level1"
export var enemies = 0
onready var player = $Player
onready var nav = $Navigation2D



var list
func _ready():
	$Player/Turret.name_of_level = levelID




func checkCompletion():
	enemies-=1
	if enemies<=0:get_tree().change_scene("res://Game_Win.tscn")
		
		
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
		bullet_instance.velocity.x = infoDict["velX"] * 0.01#for the time being it stays 0
		bullet_instance.velocity.y = infoDict["velY"] * 0.01
	bullet_instance.position = infoDict["global_position"]
	bullet_instance.rotation_degrees = infoDict["bullet_rotation"]
	bullet_instance.get_node("Tank_Area2D").bullet_size = Vector2(infoDict["bullet_size_width"],infoDict["bullet_size_height"])#infoDict["bullet_size"]
	bullet_instance.damage = infoDict["damage"]
	
	if "isEnemy" in infoDict:
	
		bullet_instance.get_child(2).set_collision_layer_bit(1,false)#removes projectile layer
		bullet_instance.get_child(2).set_collision_layer_bit(5,true)#adds enemy_projectile layer
		bullet_instance.get_child(2).set_collision_mask_bit(1,true)#Adds player collision mask
		bullet_instance.get_child(2).set_collision_mask_bit(3,false)#removes enemy collision mask
		
	
	add_child(bullet_instance)
	if infoDict["above_player"] == true:move_child(bullet_instance,0)
	
	if infoDict["name"] != "missile_launcher":move_child(bullet_instance,1)
	
	if infoDict["name"] == "pistol":bullet_instance.scale *=0.5
	


func _on_Enemy_Update_timeout():
	get_tree().call_group("Enemies","get_target_path",player.global_position)
