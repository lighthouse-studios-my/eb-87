extends Projectile
class_name CritProjectile


export(int) var shake_strength := 5

onready var _sprite := $Sprite


func _process(_delta: float) -> void:
	var offset := Vector2(shake_strength, 0).rotated(rand_range(-PI, PI))
	_sprite.position = Vector2.ZERO + offset
