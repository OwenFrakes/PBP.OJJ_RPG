extends Node

# Stats of the Player go here as variables.
var selected_player_class : PlayerClass
var selected_player_weapon : Weapon
var enemy

func stringInfo() -> String:
	return selected_player_class.getName() + "\n" + \
		   str(selected_player_class.getHealth()) + "\n" + \
		   str(selected_player_class.getStamina()) + "\n" + \
		   str(selected_player_class.getMana()) + "\n"
