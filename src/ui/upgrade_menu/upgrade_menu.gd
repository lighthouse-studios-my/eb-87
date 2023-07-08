extends HBoxContainer


signal upgrade_selected(upgrade)

var all_upgrades := [
	FireRateUpgrade.new(),
	MultishotUpgrade.new(),
	SizeUpgrade.new(),
]


func _ready() -> void:
	visible = false


func show_upgrades() -> void:
	_clear_buttons()
	var upgrades := _randomize_upgrades()
	for upgrade in upgrades:
		var button := _create_button(upgrade)
		add_child(button)
	visible = true


func _clear_buttons() -> void:
	for child in get_children():
		child.queue_free()


func _randomize_upgrades() -> Array:
	var upgrades := []
	var all = all_upgrades.duplicate()
	all.shuffle()
	upgrades.append(all.pop_back())
	upgrades.append(all.pop_back())
	return upgrades


func _create_button(upgrade: Resource) -> Button:
	var button := Button.new()
	button.icon = upgrade.icon
	button.flat = true
	button.tooltip_text = upgrade.description
	button.pressed.connect(_on_button_pressed.bind(upgrade))
	return button


func _on_button_pressed(upgrade: Resource) -> void:
	emit_signal("upgrade_selected", upgrade)
	visible = false
