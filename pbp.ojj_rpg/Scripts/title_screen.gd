extends Node2D


func startGame():
	get_tree().change_scene_to_file("res://Scenes/classSelect.tscn")

func quickStartGame():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func quitGame():
	get_tree().quit()
