extends Panel

@onready var main_menu_panel = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Button being listened for.
	if(Input.is_action_just_pressed("EscapeAction") && !$"..".inFight):
		pauseMenu()

func pauseMenu():
	if(get_tree().paused == false):
		pauseGame()
		print("A")
	
	elif(get_tree().paused == true):
		resumeGame()
		print("B")

## BUTTON SIGNAL METHODS ####################################################

# Main Menu Button
func mainMenu():
	resumeGame()
	get_tree().change_scene_to_file("res://Scenes/titleScreen.tscn")

# Quit Game Button
func quitGame():
	resumeGame()
	get_tree().quit()

#Pauses the Game and brings up the menu.
func pauseGame():
	get_tree().paused = true
	main_menu_panel.show()

#Resumes the game and hides the menu.
func resumeGame():
	get_tree().paused = false
	main_menu_panel.hide()

#func _shortcut_input(event: InputEvent) -> void:
#	if (event.is_action("EscapeAction")):
#		resumeGame()
