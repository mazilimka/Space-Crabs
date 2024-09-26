extends Node2D

var GARBAGES := [
	preload("res://Elements/Environments/Garbages/BasicGarbage/basic_garbage.tscn"),
	preload("res://Elements/Environments/Garbages/1_Garbage/1_garbage.tscn"),
	preload("res://Elements/Environments/Garbages/2_Garbage/2_garbage.tscn"),
	preload("res://Elements/Environments/Garbages/4_Garbage/4_garbage.tscn"),
	preload("res://Elements/Environments/Garbages/5_Garbage/5_garbage.tscn"),
	preload("res://Elements/Environments/Garbages/8_Garbage/8_garbage.tscn")
]



func spawn_garbage():
	var garbages_instance = GARBAGES.pick_random().instantiate()
	add_child(garbages_instance, true)
	
