extends "res://Elements/Enemies/enemy.gd"

#func death():
	#queue_redraw()


func launch_enemy_rocked():
	var enemy_rocked_instant : Area2D = enemy_rocked_scene.instantiate()
	get_parent().add_child(enemy_rocked_instant)
	enemy_rocked_instant.modulate = Color.RED
	
	enemy_rocked_instant.collision_mask = 4
	
	enemy_rocked_instant.global_position = global_position
	enemy_rocked_instant.set_direction((Global.Player.global_position - global_position).normalized(), self)
