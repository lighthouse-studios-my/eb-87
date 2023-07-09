extends VBoxContainer


func set_player_score(score) -> void:
	$Label.text = "Your Score Is: " + str(score)
