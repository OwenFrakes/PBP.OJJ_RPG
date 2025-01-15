class_name PlayerWeapon
extends Node
var wName
var damage
var attackSpeed
var type

func setWeapon(tempName: String, tempDamage: float, tempSpeed: float, tempType: String):
	wName = tempName
	damage = tempDamage
	attackSpeed = tempSpeed
	type = tempType

#get Variables
func getName():
	return wName
func getDamage():
	return damage
func getAttackSpeed():
	return attackSpeed
func getType():
	return type

#set Variables
func setName(tempName: String):
	wName = tempName
func setDamage(tempDamage: float):
	damage = tempDamage
func setAttackSpeed(tempSpeed: float):
	attackSpeed = tempSpeed
