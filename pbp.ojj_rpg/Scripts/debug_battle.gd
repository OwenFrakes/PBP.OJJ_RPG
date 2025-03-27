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
var enemy_group = [Enemy.new()]

##### PRE - _READY FUNCTIONS ############################### 

# Prepares and sets variables needed for the fight.
func readyBattle(new_player_reference, new_enemy_group):
	player_reference = new_player_reference
	enemy_group = new_enemy_group

##### _READY FUNCTION + HELPER FUNCTIONS ###################

# Handles all pre-fight info, like the move list, and the EntityInfos.
func _ready() -> void:
	readyAttackList(player_reference.moveset)
	readyEnemyInfo(enemy_group)
	readyPlayerInfo()

# Makes all of the player's moves into buttons that can be pressed.
func readyAttackList(attack_list : Array = [Attack.new()]):
	for player_attack in attack_list:
		var center_container = CenterContainer.new()
		attacks_container.add_child(center_container)
		var attack_btn = AttackButton.new(player_attack)
		attack_btn.send_attack.connect(setSelectedAttack)
		center_container.add_child(attack_btn)
		attacks.append(attack_btn)

# Makes the EntityInfo's for the enemies.
func readyEnemyInfo(enemies : Array):
	for enemy_number in range(enemies.size()):
		var enemy_info_entity = EntityInfo.new(enemies[enemy_number].getName(), enemies[enemy_number].enemy_sprite_frames)
		enemy_info.append(enemy_info_entity)
		
		# Set upper limits.
		enemy_info_entity.setHealthBar(enemies[enemy_number].getHealth())
		enemy_info_entity.setActionBar(enemies[enemy_number].getActionLimit())
		enemy_info_entity.isEnemy()
		
		# Connect signals
		# Make sure not to try and manipulate local variables in a global context...
		enemies[enemy_number].health_change.connect(enemy_info_entity.changeHealth)
		enemies[enemy_number].action_change.connect(enemy_info_entity.changeAction)
		
		enemy_info_entity.position = enemy_markers[enemy_number].position
		add_child(enemy_info_entity)

# Makes the EntityInfo for the player.
func readyPlayerInfo():
	player_info = EntityInfo.new("Player", player_reference.player_animated_sprite.sprite_frames)
	player_info.z_index = 100
	
	# Set upper limits.
	player_info.setHealthBar(player_reference.getMaxHealth(), player_reference.getHealth())
	player_info.setManaBar(player_reference.getMaxMana(), player_reference.getMana())
	player_info.setActionBar(player_reference.getActionLimit())
	
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

var pause = false
func _process(delta: float) -> void:
	
	if(pause):
		pass
	
	else:
		# 1. Check for actions
		var actor = checkForActions()
		if actor != null:
			# 2. Let them act.
			if actor == player_reference:
				#Make sure player can act.
				#print("PLAYER ACTING")
				pass
			else:
				#Make sure the enemy can act.
				pause = true
				enemyAttack(actor)
				print("ENEMY ACTING")
		
		# 3. Otherwise, progress time.
		else:
			#Player first
			player_reference.actionAmountChange(delta * player_reference.getActionMultiplier() * 20)
			#player_info.changeAction(player_reference.player_action_amount)
			for enemy in enemy_group:
				enemy.actionAmountChange(delta * enemy.getActionMultiplier() * 20)
			#Then each Enemy

func checkForActions():
	#Check the player first
	if player_reference.getActionAmount() >= player_reference.getActionLimit():
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

func enemyAttack(enemy_reference : Enemy):
	enemy_reference.actionAmountZero()
	await get_tree().create_timer(0.75).timeout
	player_reference.hurt(enemy_reference.getMoveset()[0].getDamage())
	await get_tree().create_timer(0.75).timeout
	pause = false

##### ACTION FUNCTIONS #####################################

# Placeholder for now
# This needs to have the player lose or something.
func runAway():
	player_reference.setInFight(false)
	player_reference.actionSetZero()
	queue_free()

##### SIGNALS FUNCTIONS ####################################

# Connected signal for selecting an AttackButton.
func setSelectedAttack(new_attack : Attack) -> void:
	if player_reference.canAct():
		label.text = new_attack.getName()
		player_reference.actionSetZero()
		playerAttack(new_attack)
