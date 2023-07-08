extends HBoxContainer


signal selected(upgrade)

var all_upgrades := [
	FireRateUpgrade.new(),
	MultishotUpgrade.new(),
	SizeUpgrade.new(),
]


func show_upgrades() -> void:
	var upgrades := _randomize_upgrades()
	for upgrade in upgrades:
		var button := Button.new()
		button.icon = upgrade.icon
		button.tooltip_text = upgrade.description
		button.pressed.connect(_on_button_pressed.bind(upgrade))
		add_child(button)


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


func _on_button_pressed(upgrade: Resource) -> void:
	emit_signal("selected", upgrade)
