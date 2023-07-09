extends CharacterBody2D


signal dead

@export var speed := 100.0
@export var health := 1
@export var death_audio: Resource

var death_vfx = preload("res://entities/enemies/death_effect.tscn") 
var exp_orb = preload("res://entities/orb/orb.tscn")
var target = null


func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	_follow_target(delta)


func _follow_target(delta) -> void:
	if not target: return
	
	$AnimatedSprite2D.flip_h = position.x < target.position.x
	
	velocity = position.direction_to(target.position) * speed
	move_and_collide(velocity * delta)


func hurt(damage) -> void:
	health -= damage
	if health <= 0:
		die()


func die() -> void:
	play_death_sound()
	emit_signal("dead")
	
	var death_error = death_vfx.instantiate()
	death_error.position = global_position
	get_tree().root.add_child(death_error)
	
	queue_free()


func play_death_sound() -> void:
	var death_audio_player = AudioStreamPlayer2D.new()
	death_audio_player.stream = death_audio
	death_audio_player.volume_db = -5
	death_audio_player.bus = "SFX"
	get_tree().root.add_child.call_deferred(death_audio_player)
	death_audio_player.finished.connect(death_audio_player.queue_free)
	await death_audio_player.ready
	death_audio_player.play()


func _on_hurt_box_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("hurt"):
			body.hurt(1)
