extends Path2D


signal spawned(entity)

@export var spawn_entity : PackedScene 

@export var spawn_interval = 1.0 : set = set_spawn_interval, get = get_spawn_interval
@export var max_pack_size = 3 : set = set_max_pack_size
@export var max_offset_distance := 100

@onready var context: Node = get_parent()

@onready var _rng := RandomNumberGenerator.new()
@onready var _spawn_point := $SpawnPoint
@onready var _timer := $IntervalTimer


func _ready() -> void:
	_timer.wait_time = spawn_interval
	_rng.randomize()


func spawn_pack() -> void:
	_spawn_point.progress_ratio = _rng.randf()
	var pack_size := _rng.randi_range(1, max_pack_size)
	
	for _i in range(pack_size):
		spawn(_offset_position(_spawn_point.global_position))


func spawn(pos: Vector2) -> void:
	var entity := spawn_entity.instantiate()
	entity.global_position = pos
	entity.target = get_tree().get_first_node_in_group("player")
	context.add_child(entity)
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
