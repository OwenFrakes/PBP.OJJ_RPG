extends Node2D


func startGame():
	get_tree().change_scene_to_file("res://Scenes/classSelect.tscn")

func quickStartGame():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func quitGame():
	get_tree().quit()


func load_game() -> void:
	var config = ConfigFile.new()
	var result = config.load("user://playerinfo")
	
	if result == OK:
		PlayerStats.selected_player_class = config.get_value("Player", "class")
		PlayerStats.selected_player_weapon = config.get_value("Player", "weapon")
		PlayerStats.worldNum = config.get_value("Player", "worldNum")
		var loading_screen = preload("res://Scenes/loadingScreen.tscn").instantiate()
		loading_screen.scene_to_be_loaded = "res://Scenes/world.tscn"
		get_tree().root.add_child(loading_screen)
		PlayerStats.setPlayerLoc()
		
	else:
		printerr("error on load")
