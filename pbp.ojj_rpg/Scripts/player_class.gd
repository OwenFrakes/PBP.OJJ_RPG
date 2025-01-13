class_name PlayerClass
extends Node
var cName
var health
var stamina
var mana
var pWeapon: PlayerWeapon
var weakness: Array
var learnset: Array
var count = 0 
var tAttack = attack.new()

func setClass(tempName: String, temphealth: float, tempstamina: float, tempmana: float, tempWName: String, tempWDamage: float, tempWSpeed: float, tempWType: String, tempWeak: Array):
	cName = tempName
	health = temphealth
	stamina = tempstamina
	mana = tempmana
	pWeapon = PlayerWeapon.new()
	pWeapon.setWeapon(tempWName, tempWDamage, tempWSpeed, tempWType)
	weakness.resize(tempWeak.size())
	
	count = 0
	while count < tempWeak.size():
		weakness[count] = tempWeak[count]
		count += 1
	
	learnset.resize(10)
	tAttack.setAttack("basic", pWeapon.damage, 2, 0, pWeapon.type, 0)
	learnset[0] = tAttack
	
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
