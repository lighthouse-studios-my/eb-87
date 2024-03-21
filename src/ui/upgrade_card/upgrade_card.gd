extends VBoxContainer


signal selected


var upgrade : set = _set_upgrade

@onready var _button := $MarginContainer/TextureButton
@onready var _description := $Description
@onready var _animation := $AnimationPlayer

var can_select := true

var is_selected := false


func _gui_input(event):
	if can_select and event.is_action_pressed("ui_accept") and has_focus():
		select_upgrade()


func _set_upgrade(upg) -> void:
	upgrade = upg
	if not _button:
		await ready
	_button.texture_normal = upg.icon
	_description.text = upgrade.description


func select_upgrade():
	emit_signal("selected")


func _on_texture_button_mouse_entered():
	grab_focus()


func _on_texture_button_pressed():
	select_upgrade()

