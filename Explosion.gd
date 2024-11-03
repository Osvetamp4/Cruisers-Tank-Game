extends Node2D
var damage1 = 100
var damage2 = 75

func _ready():
	self.get_parent().velocity = Vector2(0,0)
	self.get_parent().incrementation = 0
	self.get_parent().get_child(0).visible = false
	$explodeSprite.play("explode")





func _on_radius1_body_entered(body):
	body.addHealth(-1 * damage1)

func _on_radius2_body_entered(body):
	
	print("bugger all")
	body.addHealth(-1 * damage2)
	$radius1/collsion1.disabled = true
	$radius2/collision2.disabled = true#At this point the explosion was originally deinstanced.
	


func _on_explodeSprite_animation_finished():
	self.get_parent().queue_free()
