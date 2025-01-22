extends Node
var pClass : PlayerClass
var classes : Array
var place: int

func _ready() -> void:
	pClass = PlayerClass.new()
	classes = []
	classes.resize(5)
	
	#Brawler
	classes[0] = PlayerClass.new("Brawler", 100, 20,20, "Fists", 40, 50)
	
	#Swordsman
	classes[1] = PlayerClass.new("Swordsman", 50, 10,6, "Sword", 40, 50)
	
	#Gun Slinger
	classes[2] = PlayerClass.new("Gun Slinger", 100, 20,8, "Revolver", 40, 50)
	
	#Engineer
	classes[3] = PlayerClass.new("Engineer", 100, 20,20, "Wrench", 40, 50)
	
	#Marksman
	classes[4] = PlayerClass.new("Marksman", 100, 20,20, "Sniper", 40, 50)
	
	#Change text to tell player what they have selected.
	pClass = classes[0]
	$"../CharacterStats".text = "Name: " + pClass.getName() + \
	"\nWeapon: " + pClass.getWeaponName() + \
	"\nHealth: " + str(pClass.getHealth()) + \
	"\nStamina:" + str(pClass.getStamina()) + \
	"\nMana:" + str(pClass.getMana()) 

func _on_pressed() -> void:
	#Cycle if more than 4, otherwise go to next class.
	if place == 4:
		place = 0
	else:
		place += 1
	print("next")
	
	#Change text to tell player what they have selected.
	pClass = classes[place]
	$"../CharacterStats".text = "Name: " + pClass.getName() + \
	"\nWeapon: " + pClass.getWeaponName() + \
	"\nHealth: " + str(pClass.getHealth()) + \
	"\nStamina:" + str(pClass.getStamina()) + \
	"\nMana:" + str(pClass.getMana()) 
	

func _on_previous_button_pressed() -> void:
	#Cycle backwards to 4 if more than 0, otherwise go to previous class.
	if place == 0:
		place = 4
	else:
		place -= 1
	print("previous") 
	
	#Change text to tell player what they have selected.
	pClass = classes[place]
	$"../CharacterStats".text = "Name: " + pClass.getName() + \
	"\nWeapon: " + pClass.getWeaponName() + \
	"\nHealth: " + str(pClass.getHealth()) + \
	"\nStamina:" + str(pClass.getStamina()) + \
	"\nMana:" + str(pClass.getMana()) 

func _on_select_button_pressed() -> void:
	#Make the global singleton have these stats.
	PlayerStats.selected_player_class = classes[place]
	PlayerStats.selected_player_weapon = classes[place].pWeapon
	#Go to next scene.
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
