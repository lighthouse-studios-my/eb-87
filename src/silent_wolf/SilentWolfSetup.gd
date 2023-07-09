extends Node

## Autoload this script to set up SlientWolf
##
## Used for leaderboard, player accounts, game states
## Update config file for api keys
##
## See https://silentwolf.com/leaderboard for more details


func _ready():
	var config = load_config()
	
	SilentWolf.configure({
		"api_key": config.get_value("silentwolf", "api_key"),
		"game_id": config.get_value("silentwolf", "game_id"),
		"log_level": 1
	})
	
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/MainPage.tscn"
	})


func load_config() -> ConfigFile:
	var config = ConfigFile.new()
	var err = config.load("res://silent_wolf/config.cfg")
	
	if err != OK:
		return
	
	return config
