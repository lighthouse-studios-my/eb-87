extends HBoxContainer


@onready var name_label: Label = $Name
@onready var score_label: Label = $Score


func set_score(number: int, name: String, score: int):
	$Number.text = str(number) + "."
	$Name.text = name
	$Score.text = str(score)
