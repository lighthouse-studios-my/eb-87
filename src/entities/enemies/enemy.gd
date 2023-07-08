extends CharacterBody2D


@export var speed := 100.0
@export var health := 1

@onready var exp_orb = preload("res://entities/orb/orb.tscn")

var target = null


func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	_follow_target(delta)


func _follow_target(delta) -> void:
	if not target: return
	
	velocity = position.direction_to(target.position) * speed
	move_and_collide(velocity * delta)


func hurt(damage) -> void:
	health -= damage
	if health <= 0:
		die()


func die() -> void:
	var orb = exp_orb.instantiate()
	orb.position = position
	var main = get_tree().root.get_node("Main")
	main.call_deferred("add_child", orb)
	orb.absorbed.connect(Callable(main, "_on_orb_absorbed"))
	queue_free()


func _on_hurt_box_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("hurt"):
			body.hurt(1)
