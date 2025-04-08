class_name Attack
extends Node
var aName: String
var damage: float
var hCost: float
var mCost: float
var type: String
var learnLevel: float
var condition = null

func _init(tName: String = "Null", tDamage: float = 1, tHCost: float = 0, tMCost: float = 0, tempType: String = "Null", tLearnLevel: float = 0, new_condition = null) -> void:
	aName = tName
	damage = tDamage
	hCost = tHCost
	mCost = tMCost
	type = tempType
	learnLevel = tLearnLevel
	condition = new_condition

func setAttack(tName: String, tDamage: float, tHCost: float, tMCost: float, tempType: String, tLearnLevel: float, new_condition = null):
	aName = tName
	damage = tDamage
	hCost = tHCost
	mCost = tMCost
	type = tempType
	learnLevel = tLearnLevel
	condition = new_condition

#get functions
func getName():
	return aName
func getDamage():
	return damage
func getHealthCost():
	return hCost
func getManaCost():
	return mCost
func getType():
	return type
func getLearnLevel():
	return learnLevel
func getActionCondition():
	return condition
