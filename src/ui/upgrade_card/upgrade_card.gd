extends VBoxContainer


signal selected


var upgrade : set = _set_upgrade

@onready var _button := $MarginContainer/TextureButton
@onready var _description := $Description
@onready var _animation := $AnimationPlayer


func _set_upgrade(upg) -> void:
	upgrade = upg
	if not _button:
		await ready
	_button.texture_normal = upg.icon


func _on_texture_button_mouse_entered():
	if upgrade:
		_description.text = upgrade.description
	_animation.play("enlarge")


func _on_texture_button_mouse_exited():
	_description.text = ""
	_animation.play("shrink")


func _on_texture_button_pressed():
	emit_signal("selected")
