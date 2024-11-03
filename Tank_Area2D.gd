extends Area2D

var bullet_size = Vector2(8,6)
func _ready():
	var shape = RectangleShape2D.new()
	shape.set_extents(bullet_size)
	var collision = CollisionShape2D.new()
	collision.set_shape(shape)
	collision.name = "Tank_Collision_Shape2D"
	add_child(collision)
