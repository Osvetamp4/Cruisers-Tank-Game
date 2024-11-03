extends StaticBody2D

export var image = "blackBarrel"

var blackBarrel = load("res://Assets/kenney_topdowntanksredux/PNG/Retina/barrelBlack_top.png")
var redBarrel = load("res://Assets/kenney_topdowntanksredux/PNG/Retina/barrelRed_top.png")
var greenBarrel = load("res://Assets/kenney_topdowntanksredux/PNG/Retina/barrelGreen_top.png")
var rustBarrel = load("res://Assets/kenney_topdowntanksredux/PNG/Retina/barrelRust_top.png")
var woodCrate = load("res://Assets/kenney_topdowntanksredux/PNG/Retina/crateWood.png")
var metalCrate = load("res://Assets/kenney_topdowntanksredux/PNG/Retina/crateMetal.png")
var barbedWood = load("res://Assets/kenney_topdowntanksredux/PNG/Retina/barricadeWood.png")


var circleList = ["blackBarrel","redBarrel","greenBarrel","rustBarrel"]
var squareList = ["woodCrate","metalCrate","barbedWood"]

var shape
var max_health = 100
var health = 100 setget addHealth
func _ready():
	
	if image == "blackBarrel":$Sprite.texture = blackBarrel
	elif image == "redBarrel": $Sprite.texture = redBarrel
	elif image == "greenBarrel": $Sprite.texture = greenBarrel
	elif image == "rustBarrel": $Sprite.texture = rustBarrel
	elif image == "woodCrate": $Sprite.texture = woodCrate
	elif image == "metalCrate": $Sprite.texture = metalCrate
	elif image == "barbedWood": $Sprite.texture = barbedWood
	
	if image in circleList:
		shape = CircleShape2D.new()
		shape.set_radius(20)
	if image in squareList:
		shape = RectangleShape2D.new()
		shape.set_extents(Vector2(24,24))
	var collision = CollisionShape2D.new()
	collision.set_shape(shape)
	collision.name = "Prop_Collision_Shape2D"
	add_child(collision)

func addHealth(damage):
	#print(damage)
	health+=damage
	$HealthBar._on_health_updated(damage)
	if health <=0:queue_free()


