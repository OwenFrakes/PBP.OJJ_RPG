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
	tAttack.setAttack("Basic Attack", pWeapon.damage, 2, 0, pWeapon.type, 1)
	learnset[0] = tAttack
	tAttack.setAttack("Moderate Fire", 15, 0, 3, "fire", 3)
	learnset[1] = tAttack
	tAttack.setAttack("Moderate Attack", pWeapon.damage * 1.5, 4, 0, pWeapon.type, 5)
	learnset[2] = tAttack
	tAttack.setAttack("Moderate Ice", 15, 0, 3, "ice", 7)
	learnset[3] = tAttack
	tAttack.setAttack("Moderate Electric", 15, 0, 3, "electric", 9)
	learnset[4] = tAttack
	tAttack.setAttack("MASSIVE Attack", pWeapon.damage * 2, 10, 0, pWeapon.type, 10) #You know what else is massive? LO-
	learnset[5] = tAttack
	tAttack.setAttack("Massive Light", 30, 0, 10, "light", 12)
	learnset[6] = tAttack
	tAttack.setAttack("Massive Dark", 30, 0, 10, "dark", 14)
	learnset[7] = tAttack
	tAttack.setAttack("Massive Fire", 30, 0, 3, "fire", 16)
	learnset[8] = tAttack
	tAttack.setAttack("TMOA", pWeapon.damage * 5, 0, 50, pWeapon.type, 20)
	learnset[9] = tAttack
	
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
