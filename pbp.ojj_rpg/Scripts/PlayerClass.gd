class_name playerClass
extends Node
var cName
var health
var stamina
var mana
var pWeapon: playerWeapon

	
func setClass(tempName: String, temphealth: float, tempstamina: float, tempmana: float, tempWeapon: playerWeapon):
	cName = tempName
	health = temphealth
	stamina = tempstamina
	mana = tempmana
	pWeapon = playerWeapon.new()
	pWeapon = tempWeapon
	print(health)
	print(stamina)
	print(mana)
