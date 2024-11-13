extends Node
var pClass : playerClass
var classes : Array
var place: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pClass = playerClass.new()
	classes = []
	classes.resize(5)
	classes[0] = playerClass.new()
	classes[0].setClass("goku", 100, 20,20, "sword", 40, 50)
	classes[1] = playerClass.new()
	classes[1].setClass("luffy", 50, 10,6, "punch", 40, 50)
	classes[2] = playerClass.new()
	classes[2].setClass("steve", 100, 20,8, "revolver", 40, 50)
	classes[3] = playerClass.new()
	classes[3].setClass("chase", 100, 20,20, "pistol", 40, 50)
	classes[4] = playerClass.new()
	classes[4].setClass("goku jr", 100, 20,20, "punchy punch", 40, 50)
	

func _on_pressed() -> void:
	if place == 4:
		place = 0
	else:
		place += 1
	print("next") # Replace with function body.
	pClass = classes[place]
	print(pClass.getName())
	print(pClass.getHealth())
	print(pClass.getStamina())
	print(pClass.getMana())
	print(pClass.getWeaponName())
	print(pClass.getWeaponDamage())
	print(pClass.getWeaponSpeed())
	

func _on_previous_button_pressed() -> void:
	if place == 0:
		place = 4
	else:
		place -= 1
	print("previous") # Replace with function body.
	pClass = classes[place]
	print(pClass.getName())
	print(pClass.getHealth())
	print(pClass.getStamina())
	print(pClass.getMana())
	print(pClass.getWeaponName())
	print(pClass.getWeaponDamage())
	print(pClass.getWeaponSpeed())
