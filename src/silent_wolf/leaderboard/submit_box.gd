extends VBoxContainer


func set_player_score(score) -> void:
	$CenterContainer2/HBoxContainer/ScoreLabel.text = str(score)
