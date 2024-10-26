extends Node2D
class_name DamageControlerComponent

func damage(dmg : float):
	var _comp = Global.get_component(get_parent(), "HealthComponent")
	if _comp:
		_comp.damage(dmg)
