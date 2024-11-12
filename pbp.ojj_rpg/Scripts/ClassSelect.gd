extends Node
var pClass : playerClass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pClass = playerClass.new()

func _on_pressed() -> void:
	print("next") # Replace with function body.
	pClass.setClass(10,11,11)

func _on_previous_button_pressed() -> void:
	print("previous") # Replace with function body.
