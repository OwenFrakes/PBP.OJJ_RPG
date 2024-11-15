class_name PlayerWeapon
extends Node
var wName
var damage
var attackSpeed

func setWeapon(tempName: String, tempDamage: float, tempSpeed: float):
	wName = tempName
	damage = tempDamage
	attackSpeed = tempSpeed

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
