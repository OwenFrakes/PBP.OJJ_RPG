extends Node

#######THIS SCRIPT RUNS ON THE BATTLE CAMERA################

##Variables####
var turn_active = false
var is_player_turn = true
var enemy_group
var enemies : Array
var enemy_entity_info = []
var player_group = []
var player_entity_info = []
@onready var player_reference = $"../Player"
@onready var battle_camera = self

##Player Variables####
var player_moveset
var player_health
var player_mana
var player_class
var move_position
var enemy_position
var player_action_limit
var player_action_amount
var player_action_multiplier

##Control Nodes####
@onready var combat_control_node = $Control
@onready var attack_container = $Control/Attacks
@onready var enemy_choice = $Control/Attacks/AttackList/EnemyChoice
@onready var attack_list = $Control/Attacks/AttackList
@onready var enemy_info_positions = [$EnemyPosition1, $EnemyPosition2, $EnemyPosition3, $EnemyPosition4]
@onready var player_info_positions = [$PlayerPosition1]

var count : float

func _ready() -> void:
	# When the world is loaded, this section is too, this is disabled
	# to prevent any issues caused by the process function of this script.
	# This is enabled again when the function readyBattle() is used.
	# And it's disabled when either win or lose function is used.
	process_mode = PROCESS_MODE_DISABLED

var pause = false
var acting_player = 0
var acting_enemy = 0
func _process(delta: float) -> void:
	
	##Pause for graphics##
	if(pause):
		pass
	
	##An entity is acting.##
	elif(turn_active):
		#If it's the player's turn, just make the controls visible, the player does the rest.
		if(is_player_turn):
			controlsUsable(true)
		
		#Enemies 'act' when it's their turn.
		else:
			pause = true
			turn_active = false
			await get_tree().create_timer(1).timeout
			enemyAttack(acting_enemy)
			pause = false
	
	##Since no entity is acting, check if one can, else pass time.##
	else:
		####Check if the player can have an action.###
		for player_act in range(player_group.size()):
			if(player_action_amount >= player_action_limit):
				#Get the variables for _process ready.
				is_player_turn = true
				turn_active = true
				
				#Reset the amount of action they have.
				player_action_amount = 0
				
				#Save who acted last good data and other stuff, don't read too much into it.
				acting_player = player_act
				
				#Emphasize the acting entity
				entityGreyout(false, acting_player)
				
				#Break the Loop
				break
		
		####Loop to check if an enemy can have an action.###
		for enemy_action in range(enemies.size()):
			if(enemies[enemy_action].action_amount >= enemies[enemy_action].action_limit):
				#Get the variables for _process ready.
				is_player_turn = false
				turn_active = true
				
				#Reset the amount of action they have.
				enemies[enemy_action].action_amount = 0
				enemy_entity_info[enemy_action].changeAction(enemies[enemy_action].action_amount)
				print(enemies[enemy_action].getName() + " acted")
				
				#Save who acted last for the attack function.
				acting_enemy = enemy_action
				
				#Emphasize the acting entity
				entityGreyout(true, acting_enemy)
				
				#Break the Loop
				break
		
		if(!turn_active):
			for i in range(enemies.size()):
				enemies[i].action_amount += delta * enemies[i].action_multiplier * 20
				enemy_entity_info[i].changeAction(enemies[i].action_amount)
			
			for i in range(player_info_positions.size()):
				player_action_amount += delta * player_action_multiplier * 20
				player_entity_info[i].changeAction(player_action_amount)

#Give new variables for new battle.
func readyBattle(new_enemy):
	turn_active = false
	#Refresh Local Player Variables
	player_moveset = player_reference.getPlayerMoveset()
	player_health = player_reference.getPlayerHealth()
	player_mana = player_reference.getPlayerMana()
	player_class = player_reference.getPlayerClass()
	player_action_limit = player_reference.getPlayerActionLimit()
	player_action_amount = player_reference.getPlayerActionAmount()
	player_action_multiplier = player_reference.getPlayerActionMultiplier()
	
	#Put enemy informtaion in the labels.
	enemy_group = PlayerStats.enemy
	enemies = enemy_group.enemies
	
	#Define player party.
	player_group.clear()
	player_group.append(player_reference)
	
	#Clears the attack list from a previous battle.
	#Adds the new current attacks.
	attack_list.clear()
	count = 0
	while(count < player_moveset.size()):
		attack_list.add_item(player_moveset[count].getName(), null, true)
		count += 1
	
	
	#Clears enemy choices,
	#then gives the new, current enemies.
	enemy_choice.clear()
	count = 0
	while(count < enemies.size()):
		enemy_choice.add_item(enemies[count].getName(), null, true)
		count += 1
	
	controlsUsable(false)
	process_mode = PROCESS_MODE_INHERIT
	
	###Make the EntityInfo nodes for each participant.###
	#Enemy side.
	for enemy_num in range(enemies.size()):
		var enemy_info = EntityInfo.new(enemies[enemy_num].getName(), enemies[enemy_num].enemy_sprite_frames)
		enemy_entity_info.append(enemy_info)
		enemy_info.position = enemy_info_positions[enemy_num].position
		enemy_info.setHealthBar(enemies[enemy_num].getHealth())
		enemy_info.setActionBar(enemies[enemy_num].getActionLimit())
		enemy_info.isEnemy()
		add_child(enemy_info)
	
	#Player side.
	for player_num in range(player_group.size()):
		var player_info = EntityInfo.new("Player", player_reference.player_animated_sprite.sprite_frames)
		player_entity_info.append(player_info)
		player_info.position = player_info_positions[player_num].position
		player_info.setHealthBar(player_health)
		player_info.setActionBar(player_action_limit)
		player_info.setManaBar(player_mana)
		add_child(player_info)

###############Control Nodes#################
func entityGreyout(is_enemy : bool, entity_number : int):
	for num in range(player_group.size()):
		if(is_enemy || entity_number != acting_player):
			player_entity_info[num].greyout(true)
	
	#Make all but the acting enemy grey.
	for num in range(enemies.size()):
		if(!is_enemy || acting_enemy != num):
			enemy_entity_info[num].greyout(true)

func resetGreyout():
	for num in range(player_group.size()):
		player_entity_info[num].greyout(false)
	for num in range(enemies.size()):
		enemy_entity_info[num].greyout(false)

func controlsUsable(boolean : bool):
	if(boolean):
		enemy_choice.deselect_all()
		attack_list.deselect_all()
		combat_control_node.show()
	else:
		combat_control_node.hide()

###################Jank############################
func battleWin():
	PlayerStats.enemy.free()
	player_reference.setInFight(false)
	player_reference.switchBattleCamera(false)
	player_reference.addPlayerExperience(20.0)
	player_reference.levelUp()
	player_reference.levelUp()
	player_reference.set_collision_mask_value(2, true)
	for info in player_entity_info:
		info.free()
	player_entity_info.clear()
	for info in enemy_entity_info:
		info.free()
	enemy_entity_info.clear()
	process_mode = PROCESS_MODE_DISABLED

func battleLose():
	#PlayerStats.enemy.free()
	#player_reference.setInFight(false)
	#player_reference.switchBattleCamera(false)
	#process_mode = PROCESS_MODE_DISABLED
	battleWin()

#Show the available enemies, and then get the position of the correct attack from the player's moveset.
func onAttackSelected(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	
	#Ready the enemy selection
	enemy_choice.clear()
	for num1 in range(enemies.size()):
		enemy_choice.add_item(enemies[num1].getName(), null, true)
	
	#Show the enemy selection
	enemy_choice.visible = true
	
	#Iterate through each player attack
	#If the name of the player attack matches the selected attack, say it's the selected attack.
	#Then stop.
	for num2 in range(player_moveset.size()):
		if(player_moveset[num2].getName() == attack_list.get_item_text(index)):
			move_position = num2
			break

#Applies damage to the enemy, goes through enemy attacks on the player, 
#and makes player menus invisible for the enemy's turn.
func onEnemySelected(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	enemy_position = index
	playerAttack()
	enemy_choice.visible = false

## PLAYER METHODS #####################################################

#Removes enemy health, subtracts attack costs, removes enemies if dead, and checks to win the battle.
func playerAttack():
	#damage enemy
	enemies[enemy_position].damage(getPlayerAttack())
	enemy_entity_info[enemy_position].changeHealth(enemies[enemy_position].getHealth())
	
	#subtract requirements
	player_health -= player_moveset[move_position].getHealthCost()
	player_mana -= player_moveset[move_position].getManaCost()
	player_entity_info[0].changeHealth(player_health)
	player_entity_info[0].changeMana(player_mana)
	
	if enemies[enemy_position].getHealth() <= 0:
		enemies.remove_at(enemy_position)
		enemy_entity_info[enemy_position].free()
		enemy_entity_info.remove_at(enemy_position)
		count = 0 
	if enemies.size() == 0:
		battleWin()
	else:
		controlsUsable(false)
		turn_active = false
		resetGreyout()
		#debugCheckArray()

func getPlayerAttack() -> int:
	for enemy_weakness in enemies[enemy_position].weakness:
		if player_moveset[move_position].getType() == enemy_weakness:
			return player_moveset[move_position].getDamage() * 2
	return player_moveset[move_position].getDamage()

## ENEMY METHODS #####################################################

#Subtracts from player health.
func enemyAttack(enemy_location: int):
	player_health -= getEnemyAttack(enemy_location)
	player_entity_info[0].changeHealth(player_health)
	resetGreyout()

#this local variable of enemyPos is being fed an int from enemyAttack()
func getEnemyAttack(enemy_location: int) -> int:
	#for each of the players weaknesses, check if an enemy move matches typing.
	for player_weakness in player_class.getWeakness():
		for enemy_attack in enemies[enemy_location].moveset:
			if enemy_attack.getType() == player_weakness:
				return enemy_attack.getDamage() * 2
	return enemies[enemy_location].moveset[0].getDamage()

## DEBUG METHODS #######################################################

func debugCheckArray():
	var string = "Enemies: "
	for enemy in enemies:
		string += enemy.getName() + " "
	print(string)
	string = "InfoNodes: "
	for node in enemy_entity_info:
		string += node.name_label_node.text + " "
	print(string)
