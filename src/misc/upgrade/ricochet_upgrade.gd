class_name RicochetUpgrade
extends Resource


@export var icon := preload("res://assets/ui/upgrade_rof.png")
@export var description := "+1 Bounce off walls"


func apply(turret: Node2D) -> void:
	turret.projectile_bounce += 1
