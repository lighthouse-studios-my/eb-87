class_name LeaderboardManager
extends Node


signal score_submitted


func retrive_top_scores():
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	return sw_result.scores


func retrive_player_score():
	return


func submit_score(player_name, score):
	var sw_result: Dictionary = await SilentWolf.Scores.save_score(player_name, score).sw_save_score_complete
	var rank = await SilentWolf.Scores.get_score_position(sw_result.score_id).sw_get_position_complete
	emit_signal("score_submitted", rank.position, player_name, score)
