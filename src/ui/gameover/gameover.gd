extends Control


signal restart_pressed
signal back_pressed

@onready var leaderboard := %Leaderboard
@onready var stats_list := $Stats/StatsList

var allow_input = false


func _unhandled_input(event):
	if not allow_input: return
	
	if event.is_action_pressed("restart"):
		UiSfx.play_ui_press()
		emit_signal("restart_pressed")
	if event.is_action_pressed("pause"):
		UiSfx.play_ui_press()
		emit_signal("back_pressed")



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
	label.add_theme_color_override("font_color", Color.from_string("53c4d9", Color.CYAN))
	stats_list.add_child(label)


func _on_animation_player_animation_finished(anim_name):
	allow_input = true


func _on_exit_button_pressed():
	UiSfx.play_ui_press()
	emit_signal("back_pressed")


func _on_restart_button_pressed():
	UiSfx.play_ui_press()
	emit_signal("restart_pressed")
