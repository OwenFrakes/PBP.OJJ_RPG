class_name PlayerClass
extends Node
var cName
var health
var stamina
var mana
var wType
var pWeapon: Weapon
var pType: typing
var learnset : Array

func setClass(tempName: String, temphealth: float, tempstamina: float, tempmana: float, tempWName: String, tempWDamage: float, tempWSpeed: float, tempWType: String, tempPType: String):
	cName = tempName
	health = temphealth
	stamina = tempstamina
	mana = tempmana
	pWeapon = Weapon.new()
	wType = typing.new()
	wType.setType(tempWType)
	pWeapon.setWeapon(tempWName, tempWDamage, tempWSpeed, wType)
	pType = typing.new()
	pType.setType(tempPType)
	
	#Set Up Learnset
	learnset.resize(10)
	
	learnset[0] = attack.new()
	learnset[0].setAttack("Basic " + wType.name, tempWDamage, 0, 5, 0, wType.name, 1)
	
	learnset[1] = attack.new()
	learnset[1].setAttack("Basic " + pType.name, 10, 0, 0, 5, pType.name, 1)
	
	learnset[2] = attack.new()
	learnset[2].setAttack("Basic Healing", 0, 10, 0, 15, pType.name, 2)
	
	learnset[3] = attack.new()
	learnset[3].setAttack("Major " + wType.name, tempWDamage*2, 0, 20, 0, wType.name, 5)
	
	learnset[4] = attack.new()
	learnset[4].setAttack("Major " + pType.name, 25, 0, 0, 15, pType.name, 7)
	
	learnset[5] = attack.new()
	learnset[5].setAttack("Major Healing", 0, 20, 0, 30, pType.name, 8)

#get the Variables
func getName():
	return cName
func getHealth():
	return health
func getStamina():
	return stamina
func getMana():
	return mana
func getWeaponName():
	return pWeapon.getName()
func getWeaponDamage():
	return pWeapon.getDamage()
func getWeaponSpeed():
	return pWeapon.getAttackSpeed()

#set the Variables
func setName(tempName: String):
	cName = tempName
func setHealth(tempHealth: float):
	health = tempHealth
func setStamina(tempStamina: float):
	stamina = tempStamina
func setMana(tempMana: float):
	mana = tempMana
func setWeaponName(tempName: String):
	pWeapon.setName(tempName)
func setWeaponDamage(tempDamage: float):
	pWeapon.setDamage(tempDamage)
func setWeaponSpeed(tempSpeed: float):
	pWeapon.setAttackSpeed(tempSpeed)
