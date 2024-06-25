extends Node2D

#func _on_area_2d_body_entered(body):
	#print(body)
	#print(body.death)
	#if(body.is_in_group("Player")):
	#	print("This is script Death.gd")
	#	GameManager.setChange("res://Scene/Game Over.tscn")


func _on_area_2d_area_entered(area):
	print(area)
