extends Control


@export var next_scene: PackedScene


func _input(event):
	get_tree().change_scene_to_packed(next_scene)


func _on_animation_player_animation_finished(anim_name):
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)
