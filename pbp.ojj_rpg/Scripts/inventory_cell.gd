class_name Inventory_Cell
extends Node2D

var item = null
var button : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button = Button.new()
	button.size = Vector2(64,64)
	add_child(button)
	

func _init(new_item = null) -> void:
	item = new_item
