extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().create_timer(5.0).timeout.connect(_on_timeout)


func _on_timeout() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)
	tween.tween_callback(queue_free)
