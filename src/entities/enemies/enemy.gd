extends CharacterBody2D


@export var speed := 200.0

var target = null


func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	_follow_target(delta)


func _follow_target(delta) -> void:
	if not target: return
	
	velocity = position.direction_to(target.position) * speed
	move_and_collide(velocity * delta)


func die() -> void:
	queue_free()


func _on_hurt_box_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("hurt"):
			body.hurt()
