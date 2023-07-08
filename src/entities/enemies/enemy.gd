extends CharacterBody2D


@export var speed := 300.0

var target = null


func _physics_process(delta):
	_follow_target(delta)


func _follow_target(delta) -> void:
	if not target: return
	
	velocity = position.direction_to(target.position) * speed
	move_and_slide()


func die() -> void:
	queue_free()
