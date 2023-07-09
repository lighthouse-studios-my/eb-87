extends Node2D


const OrbScene = preload("res://entities/orb/orb.tscn")
const TrailScene := preload("res://misc/trail/trail.tscn")

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

var level := 1
var exp_points := 0
var exp_required := 3
var exp_scale := 2

var _pause_stack := 0


func _ready():
	enemy_spawn_timer.wait_time = enemy_spawn_cooldown
	MusicPlayer.loop = "game_1"


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
	player.heal()
	health_bar.health = player.health
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


func _on_enemy_spawn_timer_timeout():
	spawner.spawn_pack()
	enemy_spawn_timer.wait_time = enemy_spawn_cooldown


func _on_upgrade_menu_upgrade_selected(upgrade):
	upgrade.apply(turret)
	_unpause()


func _on_pause_screen_quit_pressed():
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
	get_tree().paused = false


func _on_player_dead():
	var gameover: Control = load("res://ui/gameover/gameover.tscn").instantiate()
	gameover.restart_pressed.connect(func ():
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
		get_tree().paused = false)
	gameover.back_pressed.connect(func ():
		get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
		get_tree().paused = false)
	$CanvasLayer.add_child(gameover)
	$CanvasLayer/PauseScreen.queue_free()
	camera.shake(50.0)
	health_bar.health = player.health
	gameover.leaderboard.player_score = game_timer._time_elapsed
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


func _on_player_damaged():
	camera.shake(20.0)
	health_bar.health = player.health


func _on_enemy_dead(enemy: Node2D):
	camera.shake(10.0)
	
	var orb = OrbScene.instantiate()
	orb.position = enemy.position
	orb.absorbed.connect(_on_orb_absorbed)
	add_child(orb)
	
	var trail := TrailScene.instantiate()
	trail.setup(orb, 20, 1, Color("d346d4"))
	add_child(trail)

func _on_spawner_spawned(entity):
	add_child(entity)
	entity.dead.connect(_on_enemy_dead.bind(entity))
