class_name SizeUpgrade
extends Resource


@export var icon: Texture
@export var description: String


func apply(turret: Node2D) -> void:
	turret.projectile_size += 0.1
