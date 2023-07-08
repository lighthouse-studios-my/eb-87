extends Node2D


@onready var player := $Player
@onready var spawner := $Spawner
@onready var turret := $Turret
@onready var upgrade_menu := $CanvasLayer/CenterContainer/UpgradeMenu


func _ready():
	pass


func _physics_process(delta):
	if is_instance_valid(player) and not player.is_queued_for_deletion():
		turret.aim_at(player.position)


func _on_enemy_spawn_timer_timeout():
	spawner.spawn_pack()


func _on_upgrade_menu_upgrade_selected(upgrade):
	upgrade.apply(turret)
