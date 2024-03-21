extends Control


@export var player_score = 0 : set = _set_player_score, get = _get_player_score

@onready var leaderboard_manager = $LeaderboardManager
@onready var score_list = %ScoreList
@onready var submit_button = %SubmitButton
@onready var submit_box = %SubmitBox


func _ready() -> void:
	return
	#render()


func render() -> void:
	_set_player_score(player_score)
	score_list.render(0, "", player_score)


func _set_player_score(score) -> void:
	player_score = score
	submit_button.player_score = player_score
	submit_box.set_player_score(player_score)


func _get_player_score() -> int:
	return player_score
