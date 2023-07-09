extends Control


@onready var time_label = $PanelContainer/MarginContainer/TimeLabel

var _time_elapsed := 0.0


func _ready():
	update_time(1)


func update_time(time: int):
	var min := time / 60
	var sec := time % 60
	time_label.text = "%0*d:%0*d" % [2, min, 2, sec]


func _process(delta):
	_time_elapsed += delta
	update_time(floor(_time_elapsed))
