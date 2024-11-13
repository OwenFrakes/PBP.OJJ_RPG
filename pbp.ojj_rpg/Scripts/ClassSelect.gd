extends Node
var pClass : playerClass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pClass = playerClass.new()

func _on_pressed() -> void:
	print("next") # Replace with function body.
	pClass.setClass("goku", 100, 20,20, "stabby", 40, 50)
	print(pClass.getName())
	print(pClass.getHealth())
	print(pClass.getStamina())
	print(pClass.getMana())
	print(pClass.getWeaponName())
	print(pClass.getWeaponDamage())
	print(pClass.getWeaponSpeed())

func _on_previous_button_pressed() -> void:
	print("previous") # Replace with function body.
