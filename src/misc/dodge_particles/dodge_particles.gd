extends CPUParticles2D


@export var duration := 1.0


func _ready() -> void:
	emitting = true
	get_tree().create_timer(duration).timeout.connect(_on_timeout)
	get_tree().create_timer(duration + 1.0).timeout.connect(queue_free)


func _on_timeout() -> void:
	emitting = false
