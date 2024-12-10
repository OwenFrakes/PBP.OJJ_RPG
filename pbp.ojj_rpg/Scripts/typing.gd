class_name typing
extends Node
var type : String
var superEffective : Array
var notEffective : Array

func setType(tempName: String):
	type = tempName
	match(type):
		"fire":
			superEffective.resize(2)
			superEffective[0] = "ice"
			superEffective[1] = "dark"
			notEffective.resize(3)
			notEffective[0] = "fire"
			notEffective[1] = "electric"
			notEffective[2] = "light"
		"ice":
			superEffective.resize(2)
			superEffective[0] = "electric"
			superEffective[1] = "pierce"
			notEffective.resize(3)
			notEffective[0] = "fire"
			notEffective[1] = "ice"
			notEffective[2] = "light"
		"electric":
			superEffective.resize(2)
			superEffective[0] = "slash"
			superEffective[1] = "bash"
			notEffective.resize(1)
			notEffective[0] = "ice"
		"slash":
			superEffective.resize(2)
			superEffective[0] = "pierce"
			superEffective[1] = "bash"
			notEffective.resize(3)
			notEffective[0] = "ice"
			notEffective[1] = "light"
			notEffective[2] = "dark"
		"pierce":
			superEffective.resize(2)
			superEffective[0] = "bash"
			superEffective[1] = "dark"
			notEffective.resize(2)
			notEffective[0] = "fire"
			notEffective[1] = "electric"
		"bash":
			superEffective.resize(4)
			superEffective[0] = "fire"
			superEffective[1] = "ice"
			superEffective[2] = "slash"
			superEffective[3] = "light"
			notEffective.resize(2)
			notEffective[0] = "electric"
			notEffective[1] = "dark"
		"light":
			superEffective.resize(4)
			superEffective[0] = "slash"
			superEffective[1] = "pierce"
			superEffective[2] = "dark"
			notEffective[3] = "ice"
			notEffective.resize(2)
			notEffective[1] = "bash"
			notEffective[2] = "light"
		"dark":
			superEffective.resize(1)
			superEffective[0] = "light"
			notEffective.resize(2)
			notEffective[0] = "ice"
			notEffective[1] = "dark"

func getSEffective():
	return superEffective

func getNEffective():
	return notEffective

func checkEffectiveness(type1: typing, type2: typing):
	var count = 0
	for each in superEffective:
		count += 1 
		print(count)
	
