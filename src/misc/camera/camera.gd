extends Camera2D


@export var secondary_target: Node2D


func _process(delta: float) -> void:
	if not secondary_target:
		return
	
	var target_offset = lerp(Vector2.ZERO, secondary_target.position - position, 0.1)
	offset = lerp(offset, target_offset, 0.1)
