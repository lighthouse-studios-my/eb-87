extends RayCast2D


@onready var line := $Line2D


func _process(delta: float) -> void:
	var end := to_local(get_collision_point()) if is_colliding() else target_position
	line.clear_points()
	line.add_point(Vector2.ZERO)
	line.add_point(end)
