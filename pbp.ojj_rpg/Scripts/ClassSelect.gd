extends Node
var pClass : playerClass
var classes : Array
var place: int

func _ready() -> void:
	pClass = playerClass.new()
	classes = []
	classes.resize(5)
	classes[0] = playerClass.new()
	classes[0].setClass("Brawler", 100, 20,20, "Fists", 40, 50)
	classes[1] = playerClass.new()
	classes[1].setClass("Swordsman", 50, 10,6, "Sword", 40, 50)
	classes[2] = playerClass.new()
	classes[2].setClass("Gun Slinger", 100, 20,8, "Revolver", 40, 50)
	classes[3] = playerClass.new()
	classes[3].setClass("Engineer", 100, 20,20, "Wrench", 40, 50)
	classes[4] = playerClass.new()
	classes[4].setClass("Marksman", 100, 20,20, "Sniper", 40, 50)
	pClass = classes[0]
	$"../CharacterStats".text = "Name: " + pClass.getName() + \
	"\nWeapon: " + pClass.getWeaponName() + \
	"\nHealth: " + str(pClass.getHealth()) + \
	"\nStamina:" + str(pClass.getStamina()) + \
	"\nMana:" + str(pClass.getMana()) 

func _on_pressed() -> void:
	if place == 4:
		place = 0
	else:
		place += 1
	print("next")
	pClass = classes[place]
	$"../CharacterStats".text = "Name: " + pClass.getName() + \
	"\nWeapon: " + pClass.getWeaponName() + \
	"\nHealth: " + str(pClass.getHealth()) + \
	"\nStamina:" + str(pClass.getStamina()) + \
	"\nMana:" + str(pClass.getMana()) 
	

func _on_previous_button_pressed() -> void:
	if place == 0:
		place = 4
	else:
		place -= 1
	print("previous") 
	pClass = classes[place]
	$"../CharacterStats".text = "Name: " + pClass.getName() + \
	"\nWeapon: " + pClass.getWeaponName() + \
	"\nHealth: " + str(pClass.getHealth()) + \
	"\nStamina:" + str(pClass.getStamina()) + \
	"\nMana:" + str(pClass.getMana()) 

func _on_select_button_pressed() -> void:
	pass
