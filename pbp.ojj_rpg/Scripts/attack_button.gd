class_name AttackButton
extends Button

signal send_attack(this_attack)
var stored_attack : Attack

func _init(new_attack : Attack) -> void:
	# Ready the attack and signal.
	stored_attack = new_attack
	
	#Icon
	match stored_attack.getType():
		"fire":
			icon = load("res://Resources/Conditions/FireCondition.png")
		"ice":
			icon = load("res://Resources/Conditions/IceCondition.png")
		"electric":
			icon = load("res://Resources/Conditions/ElectricityCondition.png")
		"light":
			icon = load("res://Resources/Conditions/Light.png")
		"dark":
			icon = load("res://Resources/Conditions/Dark.png")
		"bash":
			icon = load("res://Resources/Conditions/Bash.png")
		"slash":
			icon = load("res://Resources/Conditions/Pierce.png")
		"pierce":
			icon = load("res://Resources/Conditions/Slash.png")
	
	#Text
	text = stored_attack.getName()
	
	#Signal
	pressed.connect(sendAttackSignal)
	
	#Focus
	focus_mode = Control.FOCUS_NONE
	
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
