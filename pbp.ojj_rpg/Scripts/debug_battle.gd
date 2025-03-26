extends Node2D

#Existing Nodes
@onready var attacks_container: VBoxContainer = $BattleControl/ScrollControl/ScrollContainer/AttacksContainer
@onready var label: Label = $BattleControl/Label

@onready var player_marker: Marker2D = $PlayerMarker
@onready var enemy_marker_1: Marker2D = $EnemyMarker1
@onready var enemy_marker_2: Marker2D = $EnemyMarker2
@onready var enemy_marker_3: Marker2D = $EnemyMarker3
@onready var enemy_marker_4: Marker2D = $EnemyMarker4
@onready var enemy_markers = [enemy_marker_1, enemy_marker_2, enemy_marker_3, enemy_marker_4]

##Variables##

#Arrays of stuff pretty much
var attacks = []
var enemy_info := []
var player_info : EntityInfo

#Variables for Battle
var entity_acting = false

#Player & Enemy References
var player_reference
var enemy_group

##### PRE - _READY FUNCTIONS ############################### 

# Prepares and sets variables needed for the fight.
func readyBattle(new_player_reference, new_enemy_group):
	player_reference = new_player_reference
	enemy_group = new_enemy_group

##### _READY FUNCTION + HELPER FUNCTIONS ###################

# Handles all pre-fight info, like the move list, and the EntityInfos.
func _ready() -> void:
	readyAttackList(player_reference.moveset)
	readyEnemyInfo()
	readyPlayerInfo()

# Makes all of the player's moves into buttons that can be pressed.
func readyAttackList(attack_list : Array = [Attack.new()]):
	for player_attack in attack_list:
		var attack_btn = AttackButton.new(player_attack)
		attack_btn.send_attack.connect(setSelectedAttack)
		attacks_container.add_child(attack_btn)
		attacks.append(attack_btn)

# Makes the EntityInfo's for the enemies.
func readyEnemyInfo(enemies : Array = [Enemy.new()]):
	for enemy_number in range(enemies.size()):
		var enemy_info_entity = EntityInfo.new(enemies[enemy_number].getName(), enemies[enemy_number].enemy_sprite_frames)
		enemy_info.append(enemy_info_entity)
		
		# Set upper limits.
		enemy_info_entity.setHealthBar(enemies[enemy_number].getHealth())
		enemy_info_entity.setActionBar(enemies[enemy_number].getActionLimit())
		enemy_info_entity.isEnemy()
		
		# Connect signals
		#This is dumb, doent wont to work
		enemies[0].health_change.connect(enemy_info[0].changeHealth)
		enemies[enemy_number].action_change.connect(enemy_info_entity.changeAction)
		
		enemy_info_entity.position = enemy_markers[enemy_number].position
		add_child(enemy_info_entity)

# Makes the EntityInfo for the player.
func readyPlayerInfo():
	player_info = EntityInfo.new("Player", player_reference.player_animated_sprite.sprite_frames)
	player_info.z_index = 100
	
	# Set upper limits.
	player_info.setHealthBar(player_reference.getPlayerHealth())
	player_info.setManaBar(player_reference.getPlayerMana())
	player_info.setActionBar(player_reference.getPlayerActionLimit())
	
	# Connect signals for whenever these change.
	player_reference.health_change.connect(player_info.changeHealth)
	player_reference.mana_change.connect(player_info.changeMana)
	player_reference.action_change.connect(player_info.changeAction)
	
	#Set position so you can see it.
	player_info.position = player_marker.position
	add_child(player_info)

##### BATTLE FUNCTIONS #####################################

## Battle Order of Operations
# 1. Check if something can act.
# 2. Let those things act if they can.
# 3. Pass time


func _process(delta: float) -> void:
	
	#Check for actions
	var actor = checkForActions()
	if actor != null:
		if actor == player_reference:
			#Make sure player can act.
			#print("PLAYER ACTING")
			pass
		else:
			#Make sure the enemy can act.
			print("ENEMY ACTING")
	
	#Progress time
	else:
		#Player first
		player_reference.actionAmountChange(delta * player_reference.getPlayerActionMultiplier() * 20)
		#player_info.changeAction(player_reference.player_action_amount)
		
		#Then each Enemy

func checkForActions():
	#Check the player first
	if player_reference.getPlayerActionAmount() >= player_reference.getPlayerActionLimit():
		return player_reference
	
	#Check the enemies next
	for enemy in enemy_group:
		if enemy.getActionAmount() >= enemy.getActionLimit():
			return enemy
			break
	
	return null

func playerAttack(player_attack):
	enemy_group[0].damage(player_attack.getDamage())
	player_reference.hurt(1)
	player_reference.manaCost(1)

##### ACTION FUNCTIONS #####################################

# Placeholder for now
# This needs to have the player lose or something.
func runAway():
	player_reference.setInFight(false)
	queue_free()

##### SIGNALS FUNCTIONS ####################################

# Connected signal for selecting an AttackButton.
func setSelectedAttack(new_attack : Attack) -> void:
	if player_reference.canPlayerAct():
		label.text = new_attack.getName()
		player_reference.actionSetZero()
		playerAttack(new_attack)
