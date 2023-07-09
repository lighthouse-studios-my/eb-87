extends MarginContainer

var heart_texture := preload("res://assets/ui/hpbar_block.png")

@export var max_health := 3
@export var health := 2 : set = _set_health

@onready var _hearts := $MarginContainer/Hearts


func _ready():
	for n in range(max_health):
		var heart := _init_heart()
		_hearts.add_child(heart)


func _set_health(val: int) -> void:
	health = val
	
	if not _hearts:
		await ready
	
	for i in range(_hearts.get_children().size()):
		_hearts.get_child(i).texture = heart_texture if i < val else null


func _init_heart() -> TextureRect:
	var txt := TextureRect.new()
	txt.texture = heart_texture
	txt.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	txt.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	txt.custom_minimum_size = Vector2(32.0, 32.0)
	return txt
