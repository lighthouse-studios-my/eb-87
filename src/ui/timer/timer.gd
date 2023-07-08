extends Control


@onready var time_label = $TimeLabel


func _ready():
	update_time(1)



func update_time(time):
	var min = time / 60
	var sec = time % 60 
	time_label.text = "%0*d:%0*d" % [2, min, 2, sec]


func _process(delta):
	pass
