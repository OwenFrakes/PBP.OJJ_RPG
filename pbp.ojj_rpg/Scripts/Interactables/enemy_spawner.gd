class_name EnemySpawnerInteractable
extends "res://Scripts/Interactables/interactable.gd"

var enemy_to_spawn = preload("res://Scenes/Enemies/enemy1.tscn")
@onready var sprite = $Sprite2D

#Overridden Function
func interact():
	#Should spawn an enemy.
	var enemy_instance = enemy_to_spawn.instantiate()
	enemy_instance.position = position + Vector2(800, 0)
	enemy_instance.enemy_type = EnemyBody.ENEMY_IS_SPIDER
	get_tree().root.add_child(enemy_instance)

func highlight(boolean : bool):
	if(boolean):
		highlighted = true
		sprite.self_modulate = Color(0.6,1,0.6)
	else:
		highlighted = false
		sprite.self_modulate = Color(1,1,1)
