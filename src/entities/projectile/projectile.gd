extends CharacterBody2D
class_name Projectile


@export var speed := 3000
@export var damage := 1
@export var bounce := 0

var direction := Vector2.RIGHT


func setup(
		_damage: int, _direction: Vector2, _speed: int,
		_position: Vector2, size_scale: float,
		_bounce: int
) -> void:
	damage = _damage
	speed = _speed
	direction = _direction
	position = _position
	bounce = _bounce
	
	$Hitbox.shape.radius = $Hitbox.shape.radius * size_scale
	$Sprite.scale = $Sprite.scale * size_scale


func _physics_process(delta: float) -> void:
	move(delta)


func move(delta: float) -> void:
	velocity = speed * direction * delta
	var collision := move_and_collide(velocity)
	if collision:
		_collide(collision.get_collider(), collision.get_normal())


func despawn() -> void:
	if is_instance_valid(self) and not is_queued_for_deletion():
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	despawn()


func _collide(body: Node2D, normal: Vector2):
	if is_queued_for_deletion() or body.is_queued_for_deletion():
		return
	if body.has_method("hurt"):
		body.hurt(damage)
		despawn()
		return
	
	if bounce == 0:
		despawn()
	else:
		bounce -= 1
		direction = direction.bounce(normal)
