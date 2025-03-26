class_name Enemy
extends Node

var eName = "THE RIZZASTARD"
var health = 10
var mana = 10
var weakness: Array
var moveset: Array
var count = 0 
var action_limit = 100
var action_amount = 0
var action_multiplier = 1
var enemy_sprite_frames = load("res://Resources/Character/SpriteSets/blue_robot_set.tres")
var action_conditions = []
var damage_conditions = []

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
	
	count = 0
	while count < tWeakness.size():
		weakness[count] = tWeakness[count]
		count += 1
	
	count = 0
	while count < tMoveset.size():
		moveset[count] = tMoveset[count]
		count += 1
	randomActionLimit()

## Battle Functions ##
func damage(damage_amount: int, condition = null) -> int:
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
	
	emit_signal("health_change", health)
	return health

func actionChangeAmount(change_amount):
	action_amount += change_amount
	emit_signal("action_change", action_amount)

## Conditions ##
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

## Get Functions ##
func getName():
	return eName
func getHealth():
	return health
func getWeakness(pos: int):
	return weakness[pos]
func stringInfo() -> String:
	return eName + "\n" + str(health) + "\n" + str(mana) + "\n"
func getActionLimit():
	return action_limit
func getActionAmount():
	return action_amount
func randomActionLimit():
	action_limit = action_limit + randi_range(-10,10)
