extends CenterContainer


signal upgrade_selected(upgrade)

const UpgradeCardScene := preload("res://ui/upgrade_card/upgrade_card.tscn")

var all_upgrades := [
	FireRateUpgrade.new(),
	MultishotUpgrade.new(),
	SizeUpgrade.new(),
	RicochetUpgrade.new(),
]

@onready var _buttons := $Buttons
@onready var _show_audio := $ShowAudio


func _ready() -> void:
	visible = false


func show_upgrades() -> void:
	_clear_buttons()
	var upgrades := _randomize_upgrades()
	for upgrade in upgrades:
		var button := _create_button(upgrade)
		_buttons.add_child(button)
	visible = true
	_show_audio.play() 


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


func _unhandled_input(event):
	if event.is_action_pressed("move_left"):
		_buttons.get_child(0).select()
		_buttons.get_child(1).deselect()
	if event.is_action_pressed("move_right"):
		_buttons.get_child(1).select()
		_buttons.get_child(0).deselect()
