extends Control


@export var offset := 32.0
@export var animation_duration := 0.2

var _tween: Tween


func place_at(target: Control) -> void:
	if _tween:
		_tween.kill()
	size = _calculate_desired_size(target)
	global_position = _calculate_desired_pos(target)


func point_at(target: Control) -> void:
	var desired_size := _calculate_desired_size(target)
	var desired_pos := _calculate_desired_pos(target)
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_QUAD)
	_tween.tween_property(self, "size", desired_size, animation_duration)
	_tween.parallel().tween_property(self, "global_position", desired_pos, animation_duration)


func _calculate_desired_size(control: Control) -> Vector2:
	return Vector2(control.size.x + offset, control.size.y)


func _calculate_desired_pos(control: Control) -> Vector2:
	return Vector2(control.global_position.x - offset * 0.5, control.global_position.y)
