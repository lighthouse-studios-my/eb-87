extends Node2D


signal started

const OrbScene = preload("res://entities/orb/orb.tscn")
const TrailScene := preload("res://misc/trail/trail.tscn")
const ProjectileParticleScene := preload("res://misc/projectile_particle/projectile_particle.tscn")

@export var enemy_spawn_cooldown := 5.0

@onready var player := $Player
@onready var spawner := $Spawner
@onready var turret := $Turret
@onready var upgrade_menu := $CanvasLayer/UpgradeMenu
@onready var exp_bar := %ProgressBar
@onready var enemy_spawn_timer = $EnemySpawnTimer
@onready var camera := $Camera2D
@onready var health_bar := %HealthBar
@onready var game_timer = %Timer
@onready var bg := $BG
@onready var mobile_buttons = $MobileButtons

var level := 1
var exp_points := 0
var exp_required := 3
var exp_scale := 2

var _pause_stack := 0

var stats = {
	"kills" = 0,
	"upgrades" = 0,
	"damage" = 0,
	"shots" = 0,
	"time" = 0,
}


func _ready():
	enemy_spawn_timer.wait_time = enemy_spawn_cooldown
	MusicPlayer.loop = "game_1"
	
	turret.disable()
	enemy_spawn_timer.stop()
	game_timer.stop()


func _unhandled_input(event):
	# Input to start game, should only run once
	if event.is_action_pressed("dodge"):
		emit_signal("started")


func _on_orb_absorbed(exp) -> void:
	exp_points += exp
	if exp_points >= exp_required:
		level_up()
	
	update_exp_bar(exp_points, exp_required)


func update_exp_bar(exp_points, exp_required) -> void:
	exp_bar.value = exp_points
	exp_bar.max_value = exp_required


func level_up() -> void:
	exp_points = 0
	exp_required += exp_scale
	upgrade_menu.show_upgrades()
	level += 1
	_scale_difficulty()
	_scale_music()
	
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(MusicPlayer, "volume_db", -32, 1.0)
	MusicPlayer.set_playback_speed(0.5, 1)
	
	_pause()


func _scale_difficulty() -> void:
	spawner.spawn_types = min(ceil(level/2.0), 3)


func _scale_music() -> void:
	if spawner.spawn_types == 1:
		MusicPlayer.loop = "game_1"
	elif spawner.spawn_types == 2:
		MusicPlayer.loop = "game_2"
	elif spawner.spawn_types == 3:
		MusicPlayer.loop = "game_4"


func _physics_process(delta: float) -> void:
	if is_instance_valid(player) and not player.is_queued_for_deletion():
		turret.aim_at(player.position, delta)


func _pause():
	_pause_stack += 1
	get_tree().paused = true


func _unpause():
	_pause_stack -= 1
	if _pause_stack <= 0:
		get_tree().paused = false
	
	if upgrade_menu.visible:
		upgrade_menu.refocus()


func _on_enemy_spawn_timer_timeout():
	spawner.spawn_pack()
	enemy_spawn_timer.wait_time = enemy_spawn_cooldown


func _on_upgrade_menu_upgrade_selected(upgrade):
	upgrade.apply(turret)
	stats["upgrades"] += 1
	
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(MusicPlayer, "volume_db", -24, 1.0)
	
	player.heal()
	health_bar.health = player.health
	
	# Debounce player input so they don't dodge after selecting an upgrade
	player.set_process_unhandled_input(false)
	get_tree().create_timer(0.1).timeout.connect(func ():
		player.set_process_unhandled_input(true))
	
	Engine.time_scale = 0.05
	var time_tween = get_tree().create_tween()
	time_tween.tween_property(Engine, "time_scale", 1, 0.15)
	
	MusicPlayer.set_playback_speed(1, 1)
	
	_unpause()


func _on_pause_screen_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")


func _on_player_dead():
	var gameover: Control = load("res://ui/gameover/gameover.tscn").instantiate()
	gameover.restart_pressed.connect(func ():
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/main/main.tscn"))
	gameover.back_pressed.connect(func ():
		get_tree().paused = false
		get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn"))
	$CanvasLayer.add_child(gameover)
	$CanvasLayer/PauseScreen.queue_free()
	camera.shake(50.0)
	health_bar.health = player.health
	gameover.leaderboard.player_score = game_timer._time_elapsed
	gameover.leaderboard.render()
	stats["time"] = game_timer._time_elapsed
	gameover.show_stats(stats)
	mobile_buttons.visible = false
	get_tree().paused = true


func _on_pause_screen_unpaused():
	_unpause()


func _on_pause_screen_paused():
	_pause()


func _on_difficulty_timer_timeout():
	enemy_spawn_cooldown -= 0.15
	enemy_spawn_cooldown = max(enemy_spawn_cooldown, 0.5)


func _on_turret_shot(projectile):
	add_child(projectile)
	var trail := TrailScene.instantiate()
	trail.setup(projectile, projectile.size, projectile.size * 0.1, Color.WHITE)
	add_child(trail)
	
	projectile.collided.connect(func(pos: Vector2):
		var particle := ProjectileParticleScene.instantiate()
		particle.position = pos
		add_child(particle))
	
	stats["shots"] += 1


func _on_player_damaged():
	camera.shake(20.0)
	health_bar.health = player.health
	stats["damage"] += 1
	bg.flash()


func _on_enemy_dead(enemy: Node2D):
	camera.shake(10.0)
	
	var orb = OrbScene.instantiate()
	orb.position = enemy.position
	orb.absorbed.connect(_on_orb_absorbed)
	add_child(orb)
	
	var trail := TrailScene.instantiate()
	trail.setup(orb, 20, 1, Color("d346d4"))
	add_child(trail)
	stats["kills"] += 1


func _on_spawner_spawned(entity):
	add_child(entity)
	entity.dead.connect(_on_enemy_dead.bind(entity))


func _on_started() -> void:
	turret.enable()
	enemy_spawn_timer.start()
	game_timer.start()
	spawner.spawn_pack()
	disconnect("started", _on_started)
	$Tutorial.erase()
