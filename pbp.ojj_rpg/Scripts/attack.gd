class_name attack
extends Node

var aName
var damage
var heal
var hCost
var mCost
var type : typing
var learnLevel

func setAttack(tempName: String, tempDamage: float, tempHeal: float, tHCost: float, tMCost: float, tempType: String, tempLevel: float):
	aName = tempName
	damage = tempDamage
	heal = tempHeal
	hCost = tHCost
	mCost =tMCost
	learnLevel = tempLevel
	type = typing.new()
	type.setType(tempType)

func checkEffectiveness(tempType: String):
	var count = 0
	var eType = tempType
	#check not effective
	for each in type.notEffective:
		if(type.notEffective[count] == eType):
			print("not effective")
			break
		else:
			count += 1 
			print("nope")
	count = 0
	#check super effective
	for each in type.superEffective:
		if(type.superEffective[count] == eType):
			print("super effective")
			break
		else:
			count += 1 
			print("nope")
	
	
