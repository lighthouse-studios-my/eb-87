extends Control


signal upgrade_selected(upgrade)

const UpgradeCardScene := preload("res://ui/upgrade_card/upgrade_card.tscn")

var all_upgrades := [
	FireRateUpgrade.new(),
	MultishotUpgrade.new(),
	SizeUpgrade.new(),
	RicochetUpgrade.new(),
]

@onready var _buttons := %Buttons
@onready var _show_audio := $ShowAudio
@onready var _debounce := $DebounceTimer

var _last_selected: Control


func _ready() -> void:
	visible = false


func show_upgrades() -> void:
	_clear_buttons()
	var upgrades := _randomize_upgrades()
	var first: Control
	for upgrade in upgrades:
		var button := _create_button(upgrade)
		button.can_select = false
		button.focus_entered.connect(_on_button_focus_entered.bind(button))
		_buttons.add_child(button)
		if not first:
			first = button
	first.grab_focus()
		
	visible = true
	_show_audio.play()
	_debounce.start()


func refocus() -> void:
	var ui: Control
	
	if _last_selected:
		ui = _last_selected
	elif _buttons.get_child_count() > 0:
		ui = _buttons.get_child(0)
	
	if ui:
		ui.grab_focus()


func _clear_buttons() -> void:
	for child in _buttons.get_children():
		child.hide() # Hide so they don't show while getting queue_free'd
		child.queue_free()


func _randomize_upgrades() -> Array:
	var upgrades := []
	var all = all_upgrades.duplicate()
	all.shuffle()
	upgrades.append(all.pop_back())
	upgrades.append(all.pop_back())
	return upgrades


func _create_button(upgrade: Resource) -> Button:
	var button := UpgradeCardScene.instantiate()
	button.upgrade = upgrade
	button.selected.connect(_on_button_pressed.bind(upgrade))
	return button


func _on_button_pressed(upgrade: Resource) -> void:
	emit_signal("upgrade_selected", upgrade)
	UiSfx.play_upgrade_press()
	visible = false


func _on_button_focus_entered(button: Control) -> void:
	_last_selected = button


func _on_debounce_timer_timeout():
	for button in _buttons.get_children():
		button.can_select = true
