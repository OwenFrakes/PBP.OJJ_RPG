extends Node2D

# Existing Nodes
@onready var attacks_container: VBoxContainer = $BattleControl/ScrollControl/ScrollContainer/AttacksContainer
@onready var run_btn: Button = $BattleControl/ScrollControl/RunBtn

# Player Marker
@onready var player_marker: Marker2D = $PlayerMarker

# Enemy Markers
@onready var enemy_marker_1: Marker2D = $EnemyMarker1
@onready var enemy_marker_2: Marker2D = $EnemyMarker2
@onready var enemy_marker_3: Marker2D = $EnemyMarker3
@onready var enemy_marker_4: Marker2D = $EnemyMarker4
@onready var enemy_markers = [enemy_marker_1, enemy_marker_2, enemy_marker_3, enemy_marker_4]

##Variables##

#Arrays of stuff pretty much
var attacks = []
var player_info : EntityInfo
var selected_attack = null

#Enemy Variables
var enemy_related_nodes_dict = Dictionary()
var selection_buttons = []
var enemy_info := []
var battle_xp_amount = 0

#Variables for Battle
var entity_acting = false
var pause = false

#Player & Enemy References
var player_reference
var enemy_group = [Enemy.new()]
var enemy_body_reference : EnemyBody

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
	disablePlayerControls()
	totalXP()

# Makes all of the player's moves into buttons that can be pressed.
func readyAttackList(attack_list : Array = [Attack.new()]):
	for player_attack in attack_list:
		var center_container = CenterContainer.new()
		attacks_container.add_child(center_container)
		var attack_btn = AttackButton.new(player_attack)
		attack_btn.send_attack.connect(setSelectedAttack)
		center_container.add_child(attack_btn)
		attacks.append(attack_btn)
	attacks.append(run_btn)

# Makes the EntityInfo's for the enemies.
# Also, this is horrible to look at. Don't stare too long.
func readyEnemyInfo(enemies : Array):
	for enemy_number in range(enemies.size()):
		
		## Define the Info Entity
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
		enemies[enemy_number].action_condition_change.connect(enemy_info_entity.updateActionConditions)
		# Move the Info Entity to the correct position.
		enemy_info_entity.position = enemy_markers[enemy_number].position
		add_child(enemy_info_entity)
		
		## Make the Enemy Selection Button
		var selection_button = SelectionButton.new(enemies[enemy_number])
		selection_buttons.append(selection_button)
		selection_button.size = Vector2(128,128)
		selection_button.position = Vector2(-64,-64)
		selection_button.theme = load("res://Resources/Themes/ConditionTheme.tres")
		# Connect Signal
		selection_button.send_reference.connect(setEnemySelection)
		# Add and hide it.
		enemy_info_entity.add_child(selection_button)
		selection_button.hide()
		# Add an animated sprite so people can know to select it.
		var button_sprite = AnimatedSprite2D.new()
		button_sprite.autoplay = "default"
		button_sprite.sprite_frames = load("res://Resources/AttackAnimations/attack_selection.tres")
		button_sprite.position = Vector2(selection_button.size.x/2, -20)
		selection_button.add_child(button_sprite)
		
		## Dictionary Key Assignment
		enemy_related_nodes_dict.get_or_add(enemies[enemy_number], [enemy_info_entity,selection_button])

# Makes the EntityInfo for the player.
func readyPlayerInfo():
	player_info = EntityInfo.new("Player", player_reference.player_animated_sprite.sprite_frames)
	player_info.z_index = 5
	
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

func totalXP():
	for enemy in enemy_group:
		battle_xp_amount += enemy.getXPAmount()

func setBodyReference(body_reference) -> void:
	enemy_body_reference = body_reference

##### BATTLE FUNCTIONS #####################################

## Battle Order of Operations
# 1. Check if something can act.
# 2. Let those things act if they can.
# 3. Pass time

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
				enablePlayerControls()
			else:
				#Just in case.
				disablePlayerControls()
				#Make sure the enemy can act.
				pause = true
				enemyAttack(actor)
				
				#Pass time on conditions.
				actor.passActionConditions()
		
		# 3. Otherwise, progress time.
		else:
			#Player first
			player_reference.actionAmountChange(delta * player_reference.getActionMultiplier() * 20)
			#Then each Enemy
			for enemy in enemy_group:
				enemy.actionAmountChange(delta * enemy.getActionMultiplier() * 20)

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

func playerAttack(player_attack, the_enemy):
	the_enemy.damage(player_attack)
	player_reference.hurt(player_attack.getHealthCost())
	player_reference.manaCost(player_attack.getManaCost())
	
	attackAnimation(enemy_related_nodes_dict.get_or_add(the_enemy)[0].position)
	
	# Kill the enemy if they're... dead. Also remove the entity info related to it.
	if the_enemy.getHealth() <= 0:
		removeEnemy(the_enemy)
	
	# Have the player win if they're all dead.
	if enemy_group == []:
		battleWin()
	
	# Otherwise, continue as usual.
	else:
		#Reset player action amount.
		player_reference.actionSetZero()
		
		#Hide attack control and attack buttons.
		hideEnemySelection()
		disablePlayerControls()

func enemyAttack(enemy_reference : Enemy):
	enemy_reference.actionAmountZero()
	await get_tree().create_timer(0.75).timeout
	player_reference.hurt(enemy_reference.getMoveset()[0].getDamage())
	attackAnimation(player_info.position)
	await get_tree().create_timer(0.75).timeout
	pause = false

func enablePlayerControls():
	for attack_button in attacks:
		if attack_button is AttackButton && attack_button.canUse(player_reference.getMana()):
			attack_button.disabled = false
		elif attack_button is AttackButton:
			attack_button.disabled = true
		else:
			attack_button.disabled = false

func disablePlayerControls():
	for attack in attacks:
		attack.disabled = true

func showEnemySelection():
	for button in selection_buttons:
		button.show()

func hideEnemySelection():
	for button in selection_buttons:
		button.hide()

func removeEnemy(enemy_instance : Enemy):
	# Remove the related nodes first.
	var related_nodes = enemy_related_nodes_dict.get(enemy_instance)
	
	# Entity Info Removal
	for info_pos in enemy_info.size():
		if enemy_info[info_pos] == related_nodes[0]:
			enemy_info[info_pos].queue_free()
			enemy_info.remove_at(info_pos)
			break
	
	# Selection Button Removal
	for btn_pos in selection_buttons.size():
		if selection_buttons[btn_pos] == related_nodes[1]:
			selection_buttons[btn_pos].queue_free()
			selection_buttons.remove_at(btn_pos)
			break
	
	# Then remove the enemy.
	for enemy_pos in enemy_group.size():
		if enemy_group[enemy_pos] == enemy_instance:
			enemy_group[enemy_pos].queue_free()
			enemy_group.remove_at(enemy_pos)
			break

##### ACTION FUNCTIONS #####################################

# Placeholder for now
# This needs to have the player lose or something.
func runAway():
	player_reference.setInFight(false)
	player_reference.actionSetZero()
	queue_free()

func battleWin():
	# Set variables back to normal.
	player_reference.setInFight(false)
	player_reference.actionSetZero()
	
	# Give the player their XP
	player_reference.addPlayerExperience(battle_xp_amount)
	
	# Get rid of the enemy
	if enemy_body_reference == null:
		pass
	else:
		enemy_body_reference.queue_free()
	
	# Free() the battle scene.
	queue_free()

##### GUI / MISC FUNCTIONS #################################

func attackAnimation(pos : Vector2):
	var animation_sprite = AnimatedSprite2D.new()
	animation_sprite.sprite_frames = load("res://Resources/AttackAnimations/default_attack.tres")
	animation_sprite.animation_finished.connect(animation_sprite.queue_free)
	animation_sprite.position = pos
	animation_sprite.autoplay = "default"
	animation_sprite.scale = Vector2(2,2)
	animation_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	animation_sprite.z_index = 10
	add_child(animation_sprite)

##### SIGNALS FUNCTIONS ####################################

# Connected signal for selecting an AttackButton.
func setSelectedAttack(new_attack : Attack) -> void:
	if player_reference.canAct():
		# Get attack data and show enemies.
		selected_attack = new_attack
		showEnemySelection()

func setEnemySelection(selected_enemy : Enemy):
	playerAttack(selected_attack, selected_enemy)
