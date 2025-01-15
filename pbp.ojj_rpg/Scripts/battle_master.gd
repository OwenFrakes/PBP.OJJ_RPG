extends Node

#Variables
var enemy_group
@onready var debug_label = $EnemiesLabel
@onready var player_label = $PlayerLabel

#Give new variables for new battle.
func readyBattle(new_enemy):
	enemy_group = PlayerStats.enemy
	for enemy in enemy_group.enemies:
		debug_label.text += (enemy.stringInfo())
	
	player_label.text += PlayerStats.stringInfo()
