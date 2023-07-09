extends Line2D


var trail_length := 20
var source: Node2D


func setup(src: Node2D, length: int, max_size: float, color: Color) -> void:
	source = src
	trail_length = length
	default_color = color
	width_curve.set_max_value(max_size)
	width_curve.set_point_value(1, max_size)


func _process(_delta) -> void:
	if not is_instance_valid(source) or source.is_queued_for_deletion():
		source = null
	
	# delete trail if used up
	if not source and get_point_count() <= 0:
		queue_free()
		return
	
	if source:
		add_point(source.position)
	else:
		remove_point(0)
	
	# remove all excess points
	while get_point_count() > trail_length:
		remove_point(0)
