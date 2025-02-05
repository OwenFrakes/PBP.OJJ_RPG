class_name Enemy
extends Node

var eName = "THE RIZZASTARD"
var health = 10
var mana = 10
var weakness: Array
var moveset: Array
var count = 0 
var action_limit = 100
var action_amount = 0
var action_multiplier = 1

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
	randomActionLimit()

func getName():
	return eName
func getHealth():
	return health
func getWeakness(pos: int):
	return weakness[pos]
func stringInfo() -> String:
	return eName + "\n" + str(health) + "\n" + str(mana) + "\n"
func getActionLimit():
	return action_limit
func randomActionLimit():
	action_limit = action_limit + randi_range(-10,10)
