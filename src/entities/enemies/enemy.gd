extends Area2D


@export var speed := 300.0

var direction = Vector2.ZERO
var _target = null


func _physics_process(delta):
	if Input.is_action_just_pressed("dodge"): 
		_target = get_tree().root.get_node("main").get_node("Player")
	_follow_target(delta)


func _follow_target(delta) -> void:
	if not _target: return
	
	direction = position.direction_to(_target.position)
	position += direction * speed * delta


func die() -> void:
	queue_free()
