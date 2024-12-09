class_name Item_Base
extends Node

var item_name = "Pickle"
var item_icon = load("res://Resources/icon.svg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getName():
	return item_name

func _to_string() -> String:
	return item_name
