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
	volume_db = -24
	play()
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(delta):
	var position = get_playback_position()
	
	if position > loop_sections[loop][1]:
		play(loop_sections[loop][0])
