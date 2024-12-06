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
