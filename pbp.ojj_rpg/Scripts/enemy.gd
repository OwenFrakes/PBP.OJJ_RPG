class_name Enemy
extends Node

var eName = "THE RIZZASTARD"
var health = 10
var mana = 10
var weakness: Array
var moveset: Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func stringInfo() -> String:
	return eName + "\n" + str(health) + "\n" + str(mana) + "\n"
