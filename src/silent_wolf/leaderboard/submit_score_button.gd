extends Button


@export var name_text_edit_path : NodePath
@export var leaderboard_manager_path: NodePath

@onready var name_text_edit : TextEdit = get_node(name_text_edit_path)
@onready var leaderboard_manager = get_node(leaderboard_manager_path)


var player_score


func _on_pressed() -> void:
	var player_name = name_text_edit.text
	var message = validate_player_name(player_name)
	
	if message.length() == 0:
		leaderboard_manager.submit_score(player_name, player_score)
	
	disabled = true
	text = "Submitted"


func validate_player_name(player_name) -> String:
	if player_name == "":
		name_text_edit.grab_focus()
		return "Please enter a name"
	
	return ""
