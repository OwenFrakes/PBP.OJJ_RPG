class_name attack
extends Node
var aName: String
var damage: float
var hCost: float
var mCost: float
var type: String
var learnLevel: float

func setAttack(tName: String, tDamage: float, tHCost: float, tMCost: float, tempType: String, tLearnLevel: float):
	aName = tName
	damage = tDamage
	hCost = tHCost
	mCost = tMCost
	type = tempType
	learnLevel = tLearnLevel

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
