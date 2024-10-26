extends Area2D
class_name DamageAreaComponent

@export var damage_mult : float = 1.0

func damage(dmg : float):
	get_parent().damage(dmg * damage_mult)
