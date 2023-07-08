extends Node2D


signal shot(projectile)

const ProjectileScene := preload("res://entities/projectile/projectile.tscn")

@export var max_spread_angle_degrees := 10.0

@export_group("Projectile")
@export var projectile_count := 1
@export var projectile_damage := 1
@export var projectile_speed := 300
@export var projectile_size_scale := 1

var _enabled := true

@onready var _pivot := $Pivot
@onready var _tip := $Pivot/Tip
@onready var _cooldown := $CooldownTimer
@onready var _max_spread_angle := deg_to_rad(max_spread_angle_degrees)


func enable() -> void:
	_cooldown.start()


func disable() -> void:
	_cooldown.stop()


func shoot() -> void:
	for n in range(projectile_count):
		var projectile := ProjectileScene.instantiate()
		projectile.setup(
				projectile_damage,
				_calculate_direction(),
				projectile_speed,
				_tip.global_position,
				projectile_size_scale)
		emit_signal("shot", projectile)
		get_parent().add_child(projectile)
	_cooldown.start()


func aim_at(pos: Vector2) -> void:
	_pivot.rotation = lerp_angle(_pivot.rotation, get_angle_to(pos), 0.01)


func _calculate_direction() -> Vector2:
	var offset = randf_range(-_max_spread_angle, _max_spread_angle)
	return Vector2.RIGHT.rotated(_pivot.global_rotation + offset)


func _on_cooldown_timer_timeout():
	shoot()
