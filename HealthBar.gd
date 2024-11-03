extends Control

#var MAX_HEALTH = self.get_parent().max_health#Gets the health of the entity that it is attached to
#var current_health = self.get_parent().health

export (Color) var healthy_color = Color.green
export (Color) var cautious_color = Color.yellow
export (Color) var danger_color = Color.red

func _ready():
	pass

func _on_health_updated(amount):
	#current_health = self.get_parent().health#Do this to update the health total
	if self.get_parent().health == self.get_parent().max_health:self.visible = false
	else: self.visible = true
	var actual_progress = (float(amount)/self.get_parent().max_health) * 100
	$HealthBarOver.value+=actual_progress#This does the actual change of value
	$Timer.start()
	_assign_color()

func _assign_color():
	if $HealthBarOver.value > 50:$HealthBarOver.tint_progress = healthy_color
	elif $HealthBarOver.value > 25:$HealthBarOver.tint_progress = cautious_color
	else:$HealthBarOver.tint_progress = danger_color


func _on_Timer_timeout():
	$UpdateTween.interpolate_property($HealthBarUnder,"value",$HealthBarUnder.value,$HealthBarOver.value,0.4,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$UpdateTween.start()
