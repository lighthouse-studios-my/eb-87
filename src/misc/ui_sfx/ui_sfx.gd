extends AudioStreamPlayer


var ui_sfx = preload("res://assets/sfx/dock_1.wav")
var ui_press = preload("res://assets/sfx/Start_click_sound.wav")
var upgrade_press = preload("res://assets/sfx/upgrade_1.wav")


func _ready():
	bus = "SFX"


func play_ui_select() -> void:
	stream = ui_sfx
	play()


func play_ui_press() -> void:
	stream = ui_press
	play()


func play_upgrade_press() -> void:
	stream = upgrade_press
	play()
