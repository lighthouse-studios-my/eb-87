extends Node2D


signal shot(projectile)

const SPREAD_HARD_CAP := 45.0
const ProjectileScene := preload("res://entities/projectile/projectile.tscn")

@export var max_spread_angle_degrees := 0.0 : set = _set_max_spread_angle_degrees
@export var fire_rate := 1.0 : set = _set_fire_rate
@export var rotate_speed_degrees := 90.0

@export_group("Projectile")
@export var projectile_count := 1
@export var projectile_damage := 1.0
@export var projectile_speed := 300.0
@export var projectile_size_scale := 1.0
@export var projectile_bounce := 0.0

var _enabled := true

@onready var _pivot := $Pivot
@onready var _tip := $Pivot/Tip
@onready var _cooldown := $CooldownTimer
@onready var _barrel := $Pivot/Barrel
@onready var _max_spread_angle := deg_to_rad(max_spread_angle_degrees)
@onready var _rotate_speed := deg_to_rad(rotate_speed_degrees)
@onready var _shoot_audio := $ShootAudio


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
				projectile_size_scale,
				projectile_bounce)
		emit_signal("shot", projectile)
	_cooldown.start()
	_shoot_audio.play()
	
	_barrel.position.x = 34.0
	var tween := create_tween()
	tween.tween_property(_barrel, "position", Vector2(63.0, _barrel.position.y), _cooldown.wait_time)


func aim_at(pos: Vector2, delta: float) -> void:
	var pointing := Vector2.RIGHT.rotated(_pivot.rotation)
	var to := position.direction_to(pos)
	var side: int = sign(pointing.cross(to))
	var speed: float = min(_rotate_speed * delta, abs(pointing.angle_to(to)))
	_pivot.rotation += side * speed


func _calculate_direction() -> Vector2:
	var offset = randf_range(-_max_spread_angle, _max_spread_angle)
	return Vector2.RIGHT.rotated(_pivot.global_rotation + offset)


func _set_fire_rate(val: float) -> void:
	fire_rate = val
	if not _cooldown:
		await ready
	_cooldown.wait_time = 1 / fire_rate


func _set_max_spread_angle_degrees(val: float) -> void:
	max_spread_angle_degrees = min(val, SPREAD_HARD_CAP)
	_max_spread_angle = deg_to_rad(max_spread_angle_degrees)


func _on_cooldown_timer_timeout():
	shoot()
