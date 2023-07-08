extends Node2D


@onready var player := $Player
@onready var spawner := $Spawner
@onready var turret := $Turret


func _ready():
	spawner.spawn_pack()


func _physics_process(delta):
	if is_instance_valid(player) and not player.is_queued_for_deletion():
		turret.aim_at(player.position)
