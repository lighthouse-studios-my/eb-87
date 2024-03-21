extends AudioStreamPlayer


var music = preload("res://assets/music/main_menu_160_BPM_F_Min.mp3")
var loop = "menu"

var loop_sections = {
	"menu" = [22.32, 33.48],
	"game_1" = [33.48, 44.65],
	"game_2" = [55.81, 66.97],
	"game_3" = [78.14, 89.30],
	"game_4" = [100.46,111.62],
}


func _ready():
	stream = music
	volume_db = 0
	play()
	process_mode = Node.PROCESS_MODE_ALWAYS
	bus = "Music"


func _process(delta):
	var position = get_playback_position()
	
	if position > loop_sections[loop][1]:
		play(loop_sections[loop][0])


func set_playback_speed(speed: float, duration: float) -> void:
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
#	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "pitch_scale", speed, duration)
