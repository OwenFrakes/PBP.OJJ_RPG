class_name Enemy
extends Node

var title = "THE RIZZASTARD"
var health = 10
var something = 15
var rizz = "Spectatcular"
var weakness: Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func stringInfo() -> String:
	return title + "\n" + str(health) + "\n" + str(something) + "\n" + rizz
