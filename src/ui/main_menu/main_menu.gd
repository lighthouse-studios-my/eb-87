extends Control


enum Screen {
	TITLE_SCREEN,
	CREDITS,
}

@onready var _screens := {
	Screen.TITLE_SCREEN: $TitleScreen,
	Screen.CREDITS: $Credits,
}


func _ready() -> void:
	_show_screen(Screen.TITLE_SCREEN)


func _show_screen(id: Screen) -> void:
	for screen in _screens.values():
		screen.hide()
	_screens[id].show()


func _on_title_screen_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_title_screen_settings_pressed() -> void:
	pass # Replace with function body.


func _on_title_screen_credits_pressed() -> void:
	_show_screen(Screen.CREDITS)


func _on_title_screen_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_back_pressed() -> void:
	_show_screen(Screen.TITLE_SCREEN)
