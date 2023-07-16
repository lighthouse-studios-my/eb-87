extends CharacterBody2D


signal dead
signal damaged

const CharacterTexture := preload("res://assets/art/mcidle.png")
const CharacterFlippedTexture := preload("res://assets/art/mcidle_flip.png")
const DodgeParticlesScene := preload("res://misc/dodge_particles/dodge_particles.tscn")

@export var speed = 400
@export var dodge_speed = 1000
@export var health := 3

@export var dodge_duration := 0.2
@export var dodge_invul_duration := 0.1
@export var dodge_cooldown := 0.2
@export var invulnerability_duration := 1.0
@export var death_audio: Resource

@onready var _dodge_duration_timer := $DodgeDurationTimer
@onready var _dodge_cooldown_timer := $DodgeCooldownTimer
@onready var invulnerability_duration_timer := $InvulnerabilityCooldownTimer
@onready var _dodge_invul_duration_timer := $DodgeInvulDurationTimer
@onready var _animated_sprite := $AnimatedSprite2D
@onready var _heal_particles := $HealParticles

@onready var _original_health := health
@onready var _dash_audio := $DashAudio
@onready var _hurt_audio := $HurtAudio

var _is_dodging := false
var _dodge_direction := Vector2.ZERO
var _last_direction := Vector2.RIGHT
var _can_dodge := true

var is_dead = false


func _ready() -> void:
	_dodge_duration_timer.wait_time = dodge_duration
	_dodge_cooldown_timer.wait_time = dodge_cooldown
	invulnerability_duration_timer.wait_time = invulnerability_duration
	_dodge_invul_duration_timer.wait_time = dodge_invul_duration


func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	
	if direction != Vector2.ZERO:
		_last_direction = direction
	
	if _is_dodging:
		velocity = _dodge_direction.normalized() * dodge_speed
	
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
	
	if _dodge_direction == Vector2.ZERO:
		_dodge_direction = _last_direction
	
	var texture := CharacterFlippedTexture if _dodge_direction.x < 0 else CharacterTexture
	var dodge_particles := DodgeParticlesScene.instantiate()
	dodge_particles.texture = texture
	dodge_particles.duration = dodge_duration + dodge_invul_duration
	add_child(dodge_particles)
	
	_is_dodging = true
	_can_dodge = false
	_disable_collisions()
	_dodge_duration_timer.start()
	_dash_audio.play()


func hurt(damage) -> void:
	health -= damage
	
	if get_collision_layer_value(1) == false: return

	if health <= 0:
		die()
		return
	else:
		emit_signal("damaged")
	
	invulnerability_duration_timer.start()
	_disable_collisions()
	_hurt_audio.play()
	_animated_sprite.play("hurt")


func die() -> void:
	if is_dead: return
	is_dead = true
	emit_signal("dead")
	play_death_sound()
	queue_free()


func play_death_sound() -> void:
	var death_audio_player = AudioStreamPlayer2D.new()
	death_audio_player.stream = death_audio
	death_audio_player.volume_db = -5
	death_audio_player.bus = "SFX"
	death_audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child.call_deferred(death_audio_player)
	death_audio_player.finished.connect(death_audio_player.queue_free)
	await death_audio_player.ready
	death_audio_player.play()


func heal() -> void:
	health = _original_health
	_heal_particles.emitting = true


func _on_dodge_duration_timer_timeout():
	_is_dodging = false
	_dodge_invul_duration_timer.start()
	_dodge_cooldown_timer.start()


func _on_dodge_cooldown_timer_timeout():
	_can_dodge = true


func _disable_collisions() -> void:
	set_collision_layer_value(1, 0)


func _enable_collision() -> void:
	set_collision_layer_value(1, 1)
	_animated_sprite.play("idle")


func _on_invulnerability_cooldown_timer_timeout():
	_enable_collision()


func _on_dodge_invul_duration_timer_timeout():
	if invulnerability_duration_timer.is_stopped():
		_enable_collision()
