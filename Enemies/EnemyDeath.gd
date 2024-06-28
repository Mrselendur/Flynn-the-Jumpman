extends Node2D

func _on_death_area_body_entered(body):
		if(body.is_in_group("Player")):
			body.jump()
			#get_parent().queue_free()
