class_name Weapon
extends Node
var wName
var damage
var attackSpeed
var type = typing

func setWeapon(tempName: String, tempDamage: float, tempSpeed: float, tempType: typing):
	wName = tempName
	damage = tempDamage
	attackSpeed = tempSpeed
	type = typing.new()
	type.setType(tempType)

#get Variables
func getName():
	return wName
func getDamage():
	return damage
func getAttackSpeed():
	return attackSpeed

#set Variables
func setName(tempName: String):
	wName = tempName
func setDamage(tempDamage: float):
	damage = tempDamage
func setAttackSpeed(tempSpeed: float):
	attackSpeed = tempSpeed
