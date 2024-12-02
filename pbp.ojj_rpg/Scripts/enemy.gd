class_name Enemy
extends Node

var eName = "Enemy Not Found"
var health = 0
var mana = 0
var eWeapon: Weapon

# Called when the node enters the scene tree for the first time.
func setEnemy(tempName: String, temphealth: float, tempmana: float, tempWName: String, tempWDamage: float, tempWSpeed):
	eName = tempName
	health = temphealth
	mana = tempmana
	eWeapon = Weapon.new()
	eWeapon.setWeapon(tempWName, tempWDamage, tempWSpeed)

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func stringInfo() -> String:
	return "\n" + eName + "\n" + str(health) + "\n" + str(mana) + "\n" 
