class_name FireRateUpgrade
extends Resource


@export var icon: Texture
@export var description: String


func apply(turret: Node2D) -> void:
	turret.fire_rate += 0.1
