extends Camera2D


@export_range(0.0, 1.0) var decay_weight := 0.1
@export var secondary_target: Node2D

var strength := 0.0


func _process(delta: float) -> void:
	var shake_dir := _shake_screen(strength)
	var screen_offset = _offset_screen()
	offset = lerp(offset, screen_offset, 0.1) + shake_dir
	
	strength = lerp(strength, 0.0, decay_weight)


func shake(strength_: float) -> void:
	strength += strength_


func _shake_screen(strength: float) -> Vector2:
	var shake_dir := Vector2.ZERO
	if not is_equal_approx(strength, 0):
		var direction := Vector2.RIGHT.rotated(randf_range(-PI, PI))
		shake_dir = direction * strength
	return shake_dir


func _offset_screen() -> Vector2:
	if not secondary_target:
		return Vector2.ZERO
	return lerp(Vector2.ZERO, secondary_target.position - position, 0.1)
