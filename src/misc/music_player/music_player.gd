extends AudioStreamPlayer


var all_music = [
	load("res://assets/music/Call Me 130 BPM F# Min.mp3"),
	load("res://assets/music/Fight demo 3 160BPM.mp3"),
	load("res://assets/music/Fight Me BG 140 BPM C Min.mp3"),
	load("res://assets/music/Fight_160_BPM_F_Min.mp3"),
]

func _unhandled_input(event):
	if not event is InputEventKey or not event.pressed:
		return
	
	var music: AudioStream
	if event.keycode == KEY_1:
		music = all_music[0]
	elif event.keycode == KEY_2:
		music = all_music[1]
	elif event.keycode == KEY_3:
		music = all_music[2]
	elif event.keycode == KEY_4:
		music = all_music[3]
	else:
		return
	
	stream = music
	play()
