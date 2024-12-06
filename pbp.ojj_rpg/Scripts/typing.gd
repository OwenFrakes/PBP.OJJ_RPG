class_name typing
extends Node
var type : String
var strength : Array
var resist : Array

func setType(tempName: String):
	type = tempName
	match(type):
		"fire":
			strength.resize(3)
			strength[0] = "grass"
			strength[1] = "ice"
