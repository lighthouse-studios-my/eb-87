extends VBoxContainer


signal selected


var upgrade : set = _set_upgrade

@onready var _button := $MarginContainer/TextureButton
@onready var _description := $Description
@onready var _animation := $AnimationPlayer

var is_selected := false


func _unhandled_input(event):
	if is_selected:
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("dodge"):
			select_upgrade()


func _set_upgrade(upg) -> void:
	upgrade = upg
	if not _button:
		await ready
	_button.texture_normal = upg.icon


func select() -> void:
	if upgrade:
		_description.text = upgrade.description
	_animation.play("enlarge")
	is_selected = true


func deselect() -> void:
	_description.text = ""
	_animation.play("shrink")
	is_selected = false


func select_upgrade():
	emit_signal("selected")


func _on_texture_button_mouse_entered():
	select()


func _on_texture_button_mouse_exited():
	deselect()


func _on_texture_button_pressed():
	select_upgrade()
