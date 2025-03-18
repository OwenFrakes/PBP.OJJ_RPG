class_name AttackButton
extends Button

signal send_attack(this_attack)
var stored_attack : Attack

func _init(new_attack : Attack) -> void:
	stored_attack = new_attack
	text = stored_attack.getName() + " : " + stored_attack.getType()
	pressed.connect(signalThing)

func signalThing():
	emit_signal("send_attack", stored_attack)

func getAttack():
	return stored_attack

func canUse(player_mana : int) -> bool:
	if player_mana >= stored_attack.getManaCost():
		return true
	return false
