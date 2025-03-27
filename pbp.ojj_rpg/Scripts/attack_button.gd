class_name AttackButton
extends Button

signal send_attack(this_attack)
var stored_attack : Attack

func _init(new_attack : Attack) -> void:
	# Ready the attack and signal.
	stored_attack = new_attack
	icon = load("res://Resources/Conditions/FireCondition.png")
	text = stored_attack.getName()
	pressed.connect(sendAttackSignal)
	
	# Make the button look nice and big.
	custom_minimum_size = Vector2(500,100)
	theme = load("res://Resources/Themes/BattleFont.tres")
	autowrap_mode = TextServer.AUTOWRAP_WORD

func sendAttackSignal():
	emit_signal("send_attack", stored_attack)

func getAttack():
	return stored_attack

func canUse(player_mana : int) -> bool:
	if player_mana >= stored_attack.getManaCost():
		return true
	return false
