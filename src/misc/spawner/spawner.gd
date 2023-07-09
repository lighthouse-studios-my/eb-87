extends Path2D


signal spawned(entity)

@export var spawn_entities := [
	preload("res://entities/enemies/enemy.tscn"),
	preload("res://entities/enemies/variations/speedy.tscn"),
	preload("res://entities/enemies/variations/tanky.tscn"),
]

@export var spawn_interval = 1.0 : set = set_spawn_interval, get = get_spawn_interval
@export var max_pack_size = 1 : set = set_max_pack_size
@export var max_offset_distance := 200

@onready var context: Node = get_parent()

@onready var _rng := RandomNumberGenerator.new()
@onready var _spawn_point := $SpawnPoint
@onready var _timer := $IntervalTimer

var spawn_types := 1


func _ready() -> void:
	_timer.wait_time = spawn_interval
	_rng.randomize()


func spawn_pack() -> void:
	var pack_size = max_pack_size
	_spawn_point.progress_ratio = _rng.randf()
	
	for _i in range(pack_size):
		spawn(_offset_position(_spawn_point.global_position))


func spawn(pos: Vector2) -> void:
	var id = randi_range(0, spawn_types - 1)
	var entity = spawn_entities[id].instantiate()
	entity.global_position = pos
	emit_signal("spawned", entity)


func start() -> void:
	_timer.start()


func stop() -> void:
	_timer.stop()


func set_spawn_interval(val: float) -> void:
	spawn_interval = val
	if _timer:
		_timer.wait_time = val


func get_spawn_interval() -> float:
	return spawn_interval


func set_max_pack_size(val: int) -> void:
	max_pack_size = max(val, 1)


func _offset_position(pos: Vector2) -> Vector2:
	var angle := _rng.randf_range(-PI, PI)
	var direction := Vector2.RIGHT.rotated(angle)
	var vector := direction * randf() * max_offset_distance
	return pos + vector
