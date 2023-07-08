extends Node2D


@export var enemy_spawn_cooldown := 5.0

@onready var player := $Player
@onready var spawner := $Spawner
@onready var turret := $Turret
@onready var upgrade_menu := $CanvasLayer/CenterContainer/UpgradeMenu
@onready var exp_bar := $CanvasLayer/ProgressBar
@onready var enemy_spawn_timer = $EnemySpawnTimer

var exp_points = 0
var exp_required = 5
var exp_scale = 1


func _ready():
	enemy_spawn_timer.wait_time = enemy_spawn_cooldown


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
	get_tree().paused = true


func _physics_process(delta: float) -> void:
	if is_instance_valid(player) and not player.is_queued_for_deletion():
		turret.aim_at(player.position, delta)


func _on_enemy_spawn_timer_timeout():
	spawner.spawn_pack()
	enemy_spawn_timer.wait_time = enemy_spawn_cooldown


func _on_upgrade_menu_upgrade_selected(upgrade):
	upgrade.apply(turret)
	get_tree().paused = false


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
	get_tree().paused = true


func _on_difficulty_timer_timeout():
	enemy_spawn_cooldown -= 0.2
	enemy_spawn_cooldown = max(enemy_spawn_cooldown, 0.2)
	
