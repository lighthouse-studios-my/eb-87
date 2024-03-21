class_name LeaderboardManager
extends Node


signal score_submitted
signal top_percent_retrieved


func retrive_top_scores():
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	return sw_result.scores


func get_top_percent(score: int) -> void:
	var position = await get_rank(score)
	var total = await get_total_entries()
	var top = ceil(position * 100.0 / total)
	emit_signal("top_percent_retrieved", position, total, top)


func get_total_entries() -> int:
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(10000000).sw_get_scores_complete
	return sw_result.scores.size()


func get_rank(score: int) -> int:
	var rank = await SilentWolf.Scores.get_score_position(score).sw_get_position_complete
	return rank.position


func submit_score(player_name: String, score: int):
	var sw_result: Dictionary = await SilentWolf.Scores.save_score(player_name, score).sw_save_score_complete
	var rank = await SilentWolf.Scores.get_score_position(sw_result.score_id).sw_get_position_complete
	emit_signal("score_submitted", rank.position, player_name, score)
