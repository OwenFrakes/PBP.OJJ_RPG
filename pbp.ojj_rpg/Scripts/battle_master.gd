extends Node

var enemies = PlayerStats.enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for enemy in enemies:
		print(enemy.rizz)
	
	print(str(PlayerStats.selected_player_class))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
