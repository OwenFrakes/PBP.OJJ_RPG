class_name PlayerClass
extends Node
var cName
var health
var stamina
var mana
var pWeapon: PlayerWeapon
var weakness: Array
var learnset: Array


func setClass(tempName: String, temphealth: float, tempstamina: float, tempmana: float, tempWName: String, tempWDamage: float, tempWSpeed: float, tempWType: String, tempWeak: Array):
	cName = tempName
	health = temphealth
	stamina = tempstamina
	mana = tempmana
	pWeapon = PlayerWeapon.new()
	pWeapon.setWeapon(tempWName, tempWDamage, tempWSpeed, tempWType)
	weakness.resize(tempWeak.size())
	for each in tempWeak:
		weakness[each] = tempWeak[each]
	
	

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
