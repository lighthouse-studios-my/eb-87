extends Sprite2D


@export var flash_duration := 0.3
@export var flash_color := Color.RED
@export var shake_strength := 10.0

@onready var _original_color := modulate


func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	var angle := randf_range(0.0, TAU)
	var strength := randf_range(0.0, shake_strength)
	offset = Vector2.LEFT.rotated(angle) * strength


func flash() -> void:
	modulate = flash_color
	get_tree().create_timer(flash_duration, true).timeout.connect(_on_timeout)
	set_process(true)


func _on_timeout() -> void:
	modulate = _original_color
	set_process(false)
	offset = Vector2.ZERO
