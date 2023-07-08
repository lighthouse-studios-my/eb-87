class_name Projectile
extends Area2D


@export var speed := 3000
@export var damage := 1

var direction := Vector2.RIGHT


func setup(
		_damage: int, _direction: Vector2, _speed: int,
		_position: Vector2, size_scale: float
) -> void:
	damage = _damage
	speed = _speed
	direction = _direction
	position = _position
	
	$Hitbox.shape.radius = $Hitbox.shape.radius * size_scale
	$Sprite.scale = $Sprite.scale * size_scale
	print($Sprite.scale)


func _physics_process(delta: float) -> void:
	move(delta)


func move(delta: float) -> void:
	var velocity := speed * direction * delta
	position += velocity


func despawn() -> void:
	if is_instance_valid(self) and not is_queued_for_deletion():
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	despawn()


func _on_area_entered(area: Area2D):
	if is_queued_for_deletion() or area.is_queued_for_deletion():
		return
	if area.has_method("hurt"):
		area.hurt(damage)
	despawn()


func _on_body_entered(body):
	if is_queued_for_deletion() or body.is_queued_for_deletion():
		return
	if body.has_method("hurt"):
		body.hurt(damage)
	despawn()
