extends CharacterBody2D


@export var speed = 400  # speed in pixels/sec
@export var dodge_speed = 1000

@export var dodge_duration := 0.2
@export var dodge_cooldown := 0.2

@onready var _dodge_duration_timer := $DodgeDurationTimer
@onready var _dodge_cooldown_timer := $DodgeCooldownTimer

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
	_dodge_duration_timer.start()


func _on_dodge_duration_timer_timeout():
	_is_dodging = false
	_dodge_cooldown_timer.start()


func _on_dodge_cooldown_timer_timeout():
	_can_dodge = true
