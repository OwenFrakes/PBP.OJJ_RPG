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
var tAttack = Attack.new()
var sprite_set_string
var sprite_set

func setClass(tempName: String, temphealth: float, tempstamina: float, tempmana: float, tempWName: String, tempWDamage: float, tempWSpeed: float, tempWType: String, tempWeak: Array, temp_sprite_set):
	cName = tempName
	health = temphealth
	stamina = tempstamina
	mana = tempmana
	pWeapon = PlayerWeapon.new()
	pWeapon.setWeapon(tempWName, tempWDamage, tempWSpeed, tempWType)
	weakness.resize(tempWeak.size())
	sprite_set_string = temp_sprite_set
	sprite_set = load(temp_sprite_set)
	
	weakness = tempWeak

	
	learnset.resize(10)
	learnset[0] = Attack.new()
	learnset[0].setAttack("Basic Attack", pWeapon.damage, 2, 0, pWeapon.type, 1)
	learnset[1] = Attack.new()
	learnset[1].setAttack("Moderate Fire", 40, 0, 3, "fire", 3, DamageCondition.new("Fire", 3, 15))
	learnset[2] = Attack.new()
	learnset[2].setAttack("Moderate Attack", pWeapon.damage * 1.5, 4, 0, pWeapon.type, 5)
	learnset[3] = Attack.new()
	learnset[3].setAttack("Moderate Ice", 40, 0, 3, "ice", 7, ActionCondition.new("Ice", 2, -0.33))
	learnset[4] = Attack.new()
	learnset[4].setAttack("Moderate Electric", 40, 0, 3, "electric", 9)
	learnset[5] = Attack.new()
	learnset[5].setAttack("MASSIVE Attack", pWeapon.damage * 2, 10, 0, pWeapon.type, 10) #You know what else is massive? LO-
	learnset[6] = Attack.new()
	learnset[6].setAttack("Massive Light", 60, 0, 10, "light", 12)
	learnset[7] = Attack.new()
	learnset[7].setAttack("Massive Dark", 60, 0, 10, "dark", 14)
	learnset[8] = Attack.new()
	learnset[8].setAttack("Massive Fire", 60, 0, 3, "fire", 16)
	learnset[9] = Attack.new()
	learnset[9].setAttack("TMOA", pWeapon.damage * 5, 0, 50, pWeapon.type, 20)

func canLearnMove(current_level : int) -> bool:
	for move in learnset:
		if move.getLearnLevel() == current_level:
			return true
	return false

func nextMove(current_level : int):
	for move in learnset:
		if move.getLearnLevel() == current_level:
			return move

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
func getLearnset():
	return learnset
func getWeakness():
	return weakness
func getSpriteSetString():
	return sprite_set_string
func getSpriteSet():
	return sprite_set

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
func setSpriteSet(temp_set):
	sprite_set = load(temp_set)
