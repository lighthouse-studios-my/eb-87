extends Node2D


@onready var player := $Player
@onready var spawner := $Spawner


func _ready():
	spawner.spawn_pack()
