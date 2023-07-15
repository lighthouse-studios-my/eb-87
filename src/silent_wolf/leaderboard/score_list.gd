extends VBoxContainer


@export var leaderboard_manager_path: NodePath

@onready var leaderboard_manager = get_node(leaderboard_manager_path)
@onready var scores_vbox: VBoxContainer = $Scores
@onready var score_row_scene := preload("res://silent_wolf/leaderboard/score_row/score_row.tscn")


func _ready():
	custom_minimum_size = size
	leaderboard_manager.score_submitted.connect(render)
	render()


func render(player_rank = 0, player_name = "", player_score = 0) -> void:
	show_scores_loading()
	
	var scores = await leaderboard_manager.retrive_top_scores()
	
	clear_scores_list()
	
	for i in scores.size():
		add_score_row(i + 1, scores[i]["player_name"], scores[i]["score"])
	if player_rank > 10:
		var line_label = Label.new()
		line_label.text = "/*******************************"
		scores_vbox.add_child(line_label)
		add_score_row(player_rank, player_name, player_score, true)


func add_score_row(rank: int, name: String, score: int, highlight := false) -> void:
	var score_row = score_row_scene.instantiate()
	score_row.set_score(rank, name, score)
	scores_vbox.add_child(score_row)
	if highlight:
		score_row.name_label.add_theme_color_override("font_color", Color.from_string("37b93c", Color.GREEN))
		score_row.score_label.add_theme_color_override("font_color", Color.from_string("37b93c", Color.GREEN))


func show_scores_loading() -> void:
	clear_scores_list()
	
	var label = Label.new()
	label.text = "Loading..."
	scores_vbox.add_child(label)


func clear_scores_list() -> void:
	for child in scores_vbox.get_children():
		child.queue_free()
