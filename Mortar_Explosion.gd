extends Node2D


func _ready():
	$Sprite.modulate = Color(1,1,1,0)
	$Tween.interpolate_property($Sprite,"modulate",Color(1,1,1,0),Color(1,1,1,1),5,Tween.TRANS_EXPO,Tween.EASE_IN)
	$Tween.interpolate_property($Sprite,"scale",Vector2(0.3,0.3),Vector2(0.001,0.001),5,Tween.TRANS_EXPO,Tween.EASE_IN)
	$Tween.start()




func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.visible = false#We add queue free command here
	queue_free()


func _on_Tween_tween_all_completed():
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("explode")
	$Area2D/CollisionShape2D.disabled = false
