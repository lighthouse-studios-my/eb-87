extends Control


signal restart_pressed
signal back_pressed

@onready var leaderboard := %Leaderboard
@onready var stats_list := $Stats/StatsList

var allow_input = false


func _unhandled_input(event):
	if not allow_input: return
	
	if event.is_action_pressed("restart"):
		emit_signal("restart_pressed")
		UiSfx.play_ui_press()
	if event.is_action_pressed("pause"):
		emit_signal("back_pressed")
		UiSfx.play_ui_press()



func _on_button_pressed(button: String) -> void:
	emit_signal("%s_pressed" % button)
	UiSfx.play_ui_press()


func show_stats(stats) -> void:
	add_stat("Enemies Killed", stats["kills"])
	add_stat("Upgrades Taken", stats["upgrades"])
	add_stat("Damage Taken", stats["damage"])
	add_stat("Bullets Shot", stats["shots"])
	add_stat("Time Survived", stats["time"])


func add_stat(text: String, value: int) -> void:
	var label = Label.new()
	label.text = text + " : " + str(value)
	stats_list.add_child(label)


func _on_animation_player_animation_finished(anim_name):
	allow_input = true
