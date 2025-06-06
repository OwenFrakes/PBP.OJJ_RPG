extends Node

# Stats of the Player go here as variables.
var selected_player_class : PlayerClass
var selected_player_weapon
var enemy
var worldNum: int
@onready var player_item_list = "Player/PlayerMenu/Panel/ItemList"
@onready var player_node_path

func stringInfo() -> String:
	return selected_player_class.getName() + "\n" + \
		   str(selected_player_class.getHealth()) + "\n" + \
		   str(selected_player_class.getStamina()) + "\n" + \
		   str(selected_player_class.getMana()) + "\n"

func _input(_event: InputEvent) -> void:
	if(Input.is_action_just_pressed("Fullscreen_Button")):
		if(DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			
func setPlayerLoc():
	if worldNum == 1:
		Vector2(0, 1)
	elif worldNum == 2:
		Vector2(0,2)
	else:
		Vector2(0,3)
