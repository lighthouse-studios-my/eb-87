class_name MultishotUpgrade
extends Resource


@export var icon := preload("res://icon.svg")
@export var description := "Shoot additional projectiles"


func apply(turret: Node2D) -> void:
	turret.projectile_count += 1
