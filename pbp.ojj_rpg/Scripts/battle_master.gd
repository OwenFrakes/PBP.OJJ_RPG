extends Node

#######THIS SCRIPT RUNS ON THE BATTLE CAMERA################

#Variables
var enemy_group
var enemies
@onready var enemy_label = $EnemiesLabel
@onready var player_label = $PlayerLabel
@onready var player_reference = $"../Player"
@onready var battle_camera = self

##Player Variables####
var player_moveset
var player_health
var player_mana
var player_class
var move_position
var enemy_position

##Control Nodes####
@onready var attack_container = $Attacks
@onready var enemy_choice = $Attacks/AttackList/EnemyChoice
@onready var attack_list = $Attacks/AttackList

var count : float

#Give new variables for new battle.
func readyBattle(new_enemy):
	#Refresh Local Player Variables
	player_moveset = player_reference.getPlayerMoveset()
	player_health = player_reference.getPlayerHealth()
	player_mana = player_reference.getPlayerMana()
	player_class = player_reference.getPlayerClass()
	
	enemy_group = PlayerStats.enemy
	enemies = enemy_group.enemies
	for enemy in enemy_group.enemies:
		enemy_label.text += (enemy.stringInfo())
	
	player_label.text += PlayerStats.stringInfo()
	
	
	attack_list.clear()
	count = 0
	while(count < player_moveset.size()):
		attack_list.add_item(player_moveset[count].getName(), null, true)
		count += 1
	
	enemy_choice.clear()
	count = 0
	while(count < enemies.size()):
		enemy_choice.add_item(enemies[count].getName(), null, true)
		count += 1
	

###################Jank############################
func battleWin():
	PlayerStats.enemy.free()
	player_reference.setInFight(false)
	player_reference.switchBattleCamera(false)
	player_reference.addPlayerExperience(20.0)

func battleLose():
	PlayerStats.enemy.free()
	player_reference.setInFight(false)
	player_reference.switchBattleCamera(false)

#Toggle Attack Container Visibility
func _on_fight_btn_pressed() -> void:
	if attack_container.visible:
		attack_container.visible = false
	else:
		attack_container.visible = true

#Show the available enemies, and then get the position of the correct attack from the player's moveset.
func _on_attack_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	count = 0
	
	enemy_choice.clear()
	while(count < enemies.size()):
		enemy_choice.add_item(enemies[count].getName(), null, true)
		count += 1
	
	enemy_choice.visible = true
	count = 0
	while(count<player_moveset.size()):
		if(player_moveset[count].getName() == attack_list.get_item_text(count)):
			print("found")
			move_position = count
			break
		else:
			count += 1

#Applies damage to the enemy, goes through enemy attacks on the player, 
#and makes player menus invisible for the enemy's turn.
func _on_enemy_choice_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	enemy_position = index
	if enemies.size() >= 0:
		count = 0
		while (count <= enemies.size()):
			enemyAttack(count)
			count += 1
	playerAttack()
	attack_container.visible = false
	enemy_choice.visible = false

#Removes enemy health, subtracts attack costs, removes enemies if dead, and checks to win the battle.
func playerAttack():
	var enemyHP = enemies[enemy_position].getHealth()
	enemyHP -= player_moveset[move_position].getDamage() * getPlayerAttackEffectiveness()
	enemies[enemy_position].health = enemyHP
	player_health -= player_moveset[move_position].getHealthCost()
	player_mana -= player_moveset[move_position].getManaCost()
	if enemyHP <= 0:
		enemies.remove_at(move_position)
		player_label.text = "Player: \n"
		player_label.text += (str(player_class.getName()) + "\n" + str(player_health) + "\n" +  str(player_class.getStamina()) + "\n" + str(player_class.getMana()))
		enemy_label.text = "Enemies: \n"
		count = 0 
		for enemy in enemies:
			enemy_label.text += (enemy.stringInfo())
	if enemies.size() == 0:
		battleWin()
		

#Subtracts from player health.
func enemyAttack(enemy_location: int):
	var tempAttack = getEnemyAttack(enemy_location)
	player_health -= tempAttack.getDamage() * getEnemyAttackEffectiveness(tempAttack.getType(), enemy_location)

#this local variable of enemyPos is being fed an int from enemyAttack()
func getEnemyAttack(enemy_location: int):
	count = 0
	var weakCount = 0
	#for each of the players weaknesses, check if an enemy move matches typing.
	while(weakCount < player_class.getWeakness().size()):
		#for each move of the selected enemy
		while(count < enemies[enemy_location].moveset.size()):
			#If an enemy's move matches a player weakness, return that move. Else iterate
			if enemies[enemy_location].moveset[count].getType() == player_class.getWeakness()[weakCount]:
				return enemies[enemy_location].moveset[count]
			else:
				count += 1
		weakCount += 1
	return enemies[enemy_location].moveset[0]

#Goes through all of the player's weakness looking for matches.
func getEnemyAttackEffectiveness(attackType: String, enemyLoc: int):
	count = 0
	var weakCount = 0
	#for each of the players weaknesses, check if an enemy move matches typing.
	while(weakCount < player_class.getWeakness().size()):
		#for each move of the selected enemy
		while(count < enemies[enemyLoc].moveset.size()):
			#If an enemy's move matches a player weakness, return that move. Else iterate
			if enemies[enemyLoc].moveset[count].getType() == player_class.getWeakness()[weakCount]:
				return 2
			else:
				count += 1
		weakCount += 1
	return 1

func getPlayerAttackEffectiveness():
	count = 0
	while(count < enemies[enemy_position].weakness.size()):
		if(player_moveset[move_position].getType() == enemies[enemy_position].getWeakness(count)):
			return 2
		else:
			count += 1
	return 1
