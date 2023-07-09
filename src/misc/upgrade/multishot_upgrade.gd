class_name MultishotUpgrade
extends Resource


@export var icon := preload("res://assets/ui/upgrade_ms.png")
@export var description := "Shoot additional projectiles"


func apply(turret: Node2D) -> void:
	turret.max_spread_angle_degrees += 10
	turret.projectile_count += 1
