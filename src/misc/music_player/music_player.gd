extends AudioStreamPlayer


var music = preload("res://assets/music/Fight_160_BPM_F_Min.mp3")


func _ready():
	stream = music
	play()
	process_mode = Node.PROCESS_MODE_ALWAYS
