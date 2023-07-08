extends CharacterBody2D


@export var speed = 400  # speed in pixels/sec
@export var dodge_speed = 1000
@export var health := 3

@export var dodge_duration := 0.2
@export var dodge_cooldown := 0.2
@export var invulnerability_duration := 1.0

@onready var _dodge_duration_timer := $DodgeDurationTimer
@onready var _dodge_cooldown_timer := $DodgeCooldownTimer
@onready var invulnerability_duration_timer := $InvulnerabilityCooldownTimer

var _is_dodging := false
var _dodge_direction := Vector2.ZERO
var _can_dodge := true


func _ready() -> void:
	_dodge_duration_timer.wait_time = dodge_duration
	_dodge_cooldown_timer.wait_time = dodge_cooldown


func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	
	if _is_dodging:
		velocity = _dodge_direction * dodge_speed
	
	var input_axis = Input.get_axis("move_left", "move_right")
	if input_axis != 0:
		$AnimatedSprite2D.flip_h = input_axis < 0
	
	move_and_slide()


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("dodge"):
		_dodge()


func _dodge() -> void:
	if _is_dodging: return
	if not _can_dodge: return
	
	_dodge_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if _dodge_direction == Vector2.ZERO: return
	
	_is_dodging = true
	_can_dodge = false
	_disable_collisions()
	_dodge_duration_timer.start()


func hurt(damage) -> void:
	health -= damage
	
	if get_collision_layer_value(1) == false: return

	if health <= 0:
		die()
		return
	
	invulnerability_duration_timer.start()
	_disable_collisions()


func die() -> void:
	queue_free()


func _on_dodge_duration_timer_timeout():
	_is_dodging = false
	_enable_collision()
	_dodge_cooldown_timer.start()


func _on_dodge_cooldown_timer_timeout():
	_can_dodge = true


func _disable_collisions() -> void:
	set_collision_layer_value(1, 0)


func _enable_collision() -> void:
	set_collision_layer_value(1, 1)


func _on_invulnerability_cooldown_timer_timeout():
	_enable_collision()
