class_name Orb
extends Area2D


signal absorbed(exp_points)

@export var exp_points := 1 
@export var acceleration := 10
@export var target_location := Vector2(1920/2, 1080/2)

@onready var _pick_audio := $PickAudio


func _ready() -> void:
	attract()


func _draw():
	draw_circle(Vector2.ZERO, 8.0, Color("d346d4"))


func attract() -> void:
	var tween = create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", target_location, 1)
	tween.tween_callback(self.absorb)


func absorb() -> void:
	visible = false
	emit_signal("absorbed", exp_points)
	_pick_audio.play()
	_pick_audio.finished.connect(self.queue_free)
