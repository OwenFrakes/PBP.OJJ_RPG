class_name PlayerClass
extends Node
var cName
var health
var stamina
var mana
var pWeapon: PlayerWeapon

func _init(tempName: String = "", temphealth: float = 1, tempstamina: float = 1, tempmana: float = 1, tempWName: String = "", tempWDamage: float = 1, tempWSpeed = 1) -> void:
	cName = tempName 
	health = temphealth
	stamina = tempstamina
	mana = tempmana
	pWeapon = PlayerWeapon.new()
	pWeapon.setWeapon(tempWName, tempWDamage, tempWSpeed)

func setClass(tempName: String, temphealth: float, tempstamina: float, tempmana: float, tempWName: String, tempWDamage: float, tempWSpeed):
	cName = tempName
	health = temphealth
	stamina = tempstamina
	mana = tempmana
	pWeapon = PlayerWeapon.new()
	pWeapon.setWeapon(tempWName, tempWDamage, tempWSpeed)

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
