extends HBoxContainer

func set_score(number: int, name: String, score: int):
	$Number.text = str(number)
	$Name.text = name
	$Score.text = str(score)
