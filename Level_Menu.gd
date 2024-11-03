extends Control


func _ready():
	pass


func _on_Button_pressed():
	get_tree().change_scene("res://Level1.tscn")


func _on_Button2_pressed():
	get_tree().change_scene("res://Level2.tscn")


func _on_Button3_pressed():
	get_tree().change_scene("res://Level3.tscn")


func _on_Button4_pressed():
	get_tree().change_scene("res://Title_Screen.tscn")
