class_name Enemy
extends Node

var eName = "THE RIZZASTARD"
var health = 10
var mana = 10
var weakness: Array
var moveset: Array
var count = 0 


# Called when the node enters the scene tree for the first time.
func setEnemy(tName: String, tHealth: float, tMana: float, tWeakness: Array, tMoveset: Array):
	eName = tName
	health = tHealth
	mana = tMana
	weakness.resize(tWeakness.size())
	moveset.resize(tMoveset.size())
	
	count = 0
	while count < tWeakness.size():
		weakness[count] = tWeakness[count]
		count += 1
	
	count = 0
	while count < tMoveset.size():
		moveset[count] = tMoveset[count]
		count += 1

func getName():
	return eName
func getHealth():
	return health
func getWeakness(pos: int):
	return weakness[pos]
func stringInfo() -> String:
	return eName + "\n" + str(health) + "\n" + str(mana) + "\n"
