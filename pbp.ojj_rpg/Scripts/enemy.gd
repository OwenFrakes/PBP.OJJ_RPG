class_name Enemy
extends Node

# Name and Appearance
var eName = "THE RIZZASTARD"
var enemy_sprite_frames = load("res://Resources/Character/SpriteSets/blue_robot_set.tres")

# Stats
var health = 1000
var mana = 10

# Moves and Weaknesses
var weakness: Array
var moveset: Array = [Attack.new()]

# Action Variables
var action_limit = 100
var action_amount = 0
var action_multiplier = 1

# Blank Arrays for Conditions/Effects.
var action_conditions = []
var damage_conditions = []

# XP Amount
var xp_amount = 100

# Signals
signal health_change(new_health)
signal mana_change(new_mana)
signal action_change(new_action_amount)

# Called when the node enters the scene tree for the first time.
func setEnemy(tName: String, tHealth: float, tMana: float, tWeakness: Array, tMoveset: Array, new_frames: SpriteFrames = load("res://Resources/Character/SpriteSets/blue_robot_set.tres")):
	eName = tName
	health = tHealth
	mana = tMana
	weakness.resize(tWeakness.size())
	moveset.resize(tMoveset.size())
	enemy_sprite_frames = new_frames
	
	for weak_pos in tWeakness.size():
		weakness[weak_pos] = tWeakness[weak_pos]
	
	for move_pos in tMoveset.size():
		moveset[move_pos] = tMoveset[move_pos]
		
	randomActionLimit()

## Battle Functions ###########################
func damage(attack : Attack) -> int:
	var damage_amount = attack.getDamage()
	var condition = attack.getActionCondition()
	health -= damage_amount
	
	if condition is ActionCondition:
		var pre_existing = false
		for existing_condition in action_conditions:
			if condition.getName() == existing_condition.getName():
				pre_existing = true
		if !pre_existing:
			action_conditions.append(condition)
		else:
			print("Already has this condition")
	
	#print("Enemy damage(): " + int(health))
	emit_signal("health_change", health)
	return health

func actionAmountChange(change_amount):
	action_amount += change_amount
	emit_signal("action_change", action_amount)

func actionAmountZero():
	action_amount = 0
	emit_signal("action_change", action_amount)

## Conditions #################################
func totalActionConditions():
	action_multiplier = 1
	
	for action_position in action_conditions.size():
		if action_conditions[action_position].getDuration() <= 0:
			action_conditions.remove_at(action_position)
	
	for action_condition in action_conditions:
		action_multiplier += action_condition.getStrength()

func passActionConditions():
	for action_condition in action_conditions:
		action_condition.passTurn()

func randomActionLimit():
	action_limit = action_limit + randi_range(-10,10)

## Get Functions ##############################
func getName():
	return eName

func getHealth():
	return health

func getWeakness(pos: int):
	return weakness[pos]

func getMoveset():
	return moveset

func stringInfo() -> String:
	return eName + "\n" + str(health) + "\n" + str(mana) + "\n"

func getActionLimit():
	return action_limit

func getActionAmount():
	return action_amount

func getActionMultiplier():
	totalActionConditions()
	return action_multiplier

func getXPAmount():
	return xp_amount
