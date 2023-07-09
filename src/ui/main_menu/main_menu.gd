extends Control


enum Screen {
	TITLE_SCREEN,
	CREDITS,
	SETTINGS,
}

@onready var _screens := {
	Screen.TITLE_SCREEN: $TitleScreen,
	Screen.CREDITS: $Credits,
	Screen.SETTINGS: $Settings,
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
	_show_screen(Screen.SETTINGS)


func _on_title_screen_credits_pressed() -> void:
	_show_screen(Screen.CREDITS)


func _on_title_screen_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_back_pressed() -> void:
	_show_screen(Screen.TITLE_SCREEN)


func _on_settings_back_pressed():
	_show_screen(Screen.TITLE_SCREEN)
