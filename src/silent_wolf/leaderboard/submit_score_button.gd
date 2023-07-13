extends Button


signal score_submitting

@export var name_text_edit_path : NodePath
@export var leaderboard_manager_path: NodePath

@onready var name_text_edit : LineEdit = get_node(name_text_edit_path)
@onready var leaderboard_manager = get_node(leaderboard_manager_path)


var player_score


func _on_pressed() -> void:
	var player_name = name_text_edit.text
	var message = validate_player_name(player_name)
	
	name_text_edit.placeholder_text = message
	
	if message.length() == 0:
		emit_signal("score_submitting")
		leaderboard_manager.submit_score(player_name, player_score)
		disabled = true
		text = "Submitted"


func validate_player_name(player_name) -> String:
	if player_name == "":
		name_text_edit.grab_focus()
		return "You forgot your name"
	
	return ""


func _on_name_text_edit_text_submitted(new_text):
	_on_pressed()
