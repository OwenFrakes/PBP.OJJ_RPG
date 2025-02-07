class_name EnemySpawnerInteractable
extends "res://Scripts/interactable.gd"

var enemy_to_spawn = preload("res://Scenes/Enemies/enemy1.tscn")

#Overridden Function
func interact():
	#Should spawn an enemy.
	var enemy_instance = enemy_to_spawn.instantiate()
	enemy_instance.position = position + Vector2(800, 0)
	get_tree().root.add_child(enemy_instance)
	
