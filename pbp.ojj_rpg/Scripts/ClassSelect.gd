extends Node
var pClass : playerClass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_pressed() -> void:
	print("pressed")
	pClass.setClass(10,10,10)
