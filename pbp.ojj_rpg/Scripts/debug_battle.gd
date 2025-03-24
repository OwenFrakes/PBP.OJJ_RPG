extends Node2D

#Existing Nodes
@onready var attacks_container: VBoxContainer = $BattleControl/ScrollControl/ScrollContainer/AttacksContainer
@onready var label: Label = $BattleControl/Label

#Variables
var selected_attack : Attack
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

# Makes all of the player's moves into buttons that can be pressed.
func readyAttackList(attack_list : Array = [Attack.new()]):
	for player_attack in attack_list:
		var attack_btn = AttackButton.new(player_attack)
		attack_btn.send_attack.connect(setSelectedAttack)
		attacks_container.add_child(attack_btn)

# Makes the EntityInfo's for the enemies.
func readyEnemyInfo():
	pass

# Makes the EntityInfo for the player.
func readyPlayerInfo():
	pass

##### ACTION FUNCTIONS #####################################

# Placeholder for now
# This needs to have the player lose or something.
func runAway():
	player_reference.setInFight(false)
	queue_free()

##### SIGNALS FUNCTIONS ####################################

# Connected signal for selecting an AttackButton.
func setSelectedAttack(new_attack : Attack) -> void:
	selected_attack = new_attack
	label.text = selected_attack.getName()
