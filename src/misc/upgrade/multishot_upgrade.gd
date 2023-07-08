class_name MultishotUpgrade
extends Resource


@export var icon: Texture
@export var description: String


func apply(turret: Node2D) -> void:
	turret.projectile_count += 1
