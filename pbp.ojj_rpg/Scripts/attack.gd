class_name attack
extends Node

var aName
var damage
var hCost
var mCost
var type : typing

func setAttack(tempName: String, tempDamage: float, tHCost: float, tMCost: float, tempType: String):
	aName = tempName
	damage = tempDamage
	hCost = tHCost
	mCost =tMCost
	type = typing.new()
	type.setType(tempType)

func checkEffectiveness(tempType: String):
	var count = 0
	var eType = tempType
	for each in type.notEffective:
		if(type.notEffective[count] == eType):
			print("not effective")
			break
		else:
			count += 1 
			print("nope")
	count = 0
	for each in type.superEffective:
		if(type.superEffective[count] == eType):
			print("super effective")
			break
		else:
			count += 1 
			print("nope")
	
	
