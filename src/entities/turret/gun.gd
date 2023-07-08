extends Node2D


signal shot(charge_level)
signal reloaded
signal cocked

const ProjectileScene := preload("res://entities/projectile/projectile.tscn")
const CritProjectileScene := preload("res://entities/projectile/crit_projectile/crit_projectile.tscn")

export var _charge_speed := 1.0
export var _max_projectiles := 10
export var _min_damage := 10
export var _damage_coefficient := 100
export var _min_speed := 100
export var _speed_coefficient := 1000
export var _max_spread_angle_degrees := 60
export var _size_coefficient := 3.0
export var _indicator_length := 128
export(Color) var _indicator_base_color := Color.white
export(Color) var _indicator_crit_color := Color.white
export var _max_trail_length := 20

var charge_level: float
var can_shoot := true

var _enabled := true
var _x: float
var shoot_count := 0

onready var context: Node = get_parent()

onready var _barrel := $Tip
onready var _left_spread_boundary := $LeftSpreadBoundary
onready var _right_spread_boundary := $RightSpreadBoundary
onready var _cooldown := $CooldownTimer
onready var _tween := $Tween


func _physics_process(delta: float) -> void:
	if not _enabled:
		return
	
	if can_shoot and Input.is_action_pressed("action"):
		_show_spread_boundaries(true)
		_charge(delta * _charge_speed)
		_update_boundaries_position()
	
	var is_crit := _calculate_projectile_count() == 1
	var color := _indicator_crit_color if is_crit else _indicator_base_color
	_left_spread_boundary.default_color = color
	_right_spread_boundary.default_color = color


func _unhandled_input(event: InputEvent):
	if not _enabled:
		return
	
	if event.is_action_pressed("action"):
		_reset_charge()
		_update_boundaries_position()
		emit_signal("cocked")
		
	if can_shoot and event.is_action_released("action"):
		_show_spread_boundaries(false)
		_shoot()


func setup(ctx: Node) -> void:
	context = ctx


func enable() -> void:
	_enabled = true


func disable() -> void:
	_enabled = false


func _charge(val: float) -> void:
	_x += val
	charge_level = 2 * abs(_x - floor(_x + 0.5)) # Map cosine to values between 0 and 1


func _reset_charge() -> void:
	_x = 0
	charge_level = 0


func _shoot() -> void:
	var projectile_count := _calculate_projectile_count()
	var damage := charge_level * _damage_coefficient + _min_damage
	var speed := charge_level * _speed_coefficient + _min_speed
	var size_scale := charge_level * _size_coefficient + 1
	var trail_length := charge_level * _max_trail_length + 2
	var spread := _calculate_spread()
	var is_crit := projectile_count == 1
	
	for n in range(projectile_count):
		var projectile := CritProjectileScene.instance() if is_crit else ProjectileScene.instance()
		projectile.trail_length = trail_length
		context.add_child(projectile)
		projectile.setup(
				damage,
				_calculate_direction(projectile_count, n, spread),
				speed,
				_barrel.global_position,
				size_scale,
				is_crit,
				shoot_count)
		projectile.context = context
	
	emit_signal("shot", charge_level)
	_animate_barrel()
	
	$ShootSound.play()
	if is_crit:
		$CritSound.play()
	
	shoot_count += 1
	can_shoot = false
	_cooldown.start()


func _calculate_direction(count: int, index: int, spread: float) -> Vector2:
	var offset = 0.0
	
	if count > 1:
		offset = range_lerp(index, 0, count - 1, -spread, spread)
	
	return Vector2.LEFT.rotated(global_rotation + offset)


func _calculate_spread() -> float:
	return range_lerp(charge_level, 1.0, 0.0, 0, deg2rad(_max_spread_angle_degrees))


func _calculate_projectile_count() -> int:
	var count := int(charge_level * -_max_projectiles) + _max_projectiles
	if count % 2 == 0:
		count += 1
	return count


func _show_spread_boundaries(show: bool) -> void:
	_left_spread_boundary.visible = show
	_right_spread_boundary.visible = show


func _update_boundaries_position() -> void:
	var spread := _calculate_spread()
	
	var _left_points: PoolVector2Array = _left_spread_boundary.points
	_left_points[1] = Vector2.LEFT.rotated(rotation - spread) * _indicator_length
	_left_spread_boundary.points = _left_points
	
	var _right_points: PoolVector2Array = _right_spread_boundary.points
	_right_points[1] = Vector2.LEFT.rotated(rotation + spread) * _indicator_length
	_right_spread_boundary.points = _right_points


func _animate_barrel() -> void:
	var x := 48 - charge_level * 48
	_tween.interpolate_property($Barrel, "position", Vector2(-x, 0), Vector2(-52, 0),
			_cooldown.wait_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	_tween.start()


func _on_CooldownTimer_timeout():
	can_shoot = true
	emit_signal("reloaded")
