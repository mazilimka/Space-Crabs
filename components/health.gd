extends Node
class_name HealthComponent

@export var max_health : float = 100
@export var health : float = 100

signal zero_health
signal damaged

func set_health(value: float):
	health = min(value, max_health)
	if health <= 0:
		zero_health.emit()
		death()
	pass

func damage(dmg : float):
	set_health( health - dmg)
	damaged.emit()
	pass

func heal(amount: float):
	set_health( health + amount)
	pass

func death():
	get_parent().queue_free()
	pass
