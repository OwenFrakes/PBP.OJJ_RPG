class_name EnemyBody
extends Sprite2D

#Sprite / Tile size
var tile_size = 64.0

#Variables
var desired_position = position
var movement_cooldown = 0
@onready var player = $"../Player"
var player_position : Vector2
var detection_range = 8
var inFight = false
var enemies = []
@onready var map_tile_set = $"../World Terrain"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var posX = (int(position.x / tile_size) * tile_size) + (tile_size / 2)
	var posY = (int(position.y / tile_size) * tile_size) + (tile_size / 2)
	position = Vector2(posX, posY)
	desired_position = Vector2(posX, posY)
	
	scale = Vector2(tile_size/texture.get_width(), tile_size/texture.get_height())
	
	enemies.append(Enemy.new())
	enemies.append(Enemy.new())
	enemies.append(Enemy.new())

func move(point : Vector2, delta : float):
	if(movement_cooldown <= 0):
		#Get wether the enemy is farther from the player in the y or x dimension.
		var xDiff = player_position.x - position.x
		var yDiff = player_position.y - position.y
		
		#Get predicted tile.
		var tile_pos = map_tile_set.local_to_map(position)
		var next_tile_x = map_tile_set.local_to_map(position + Vector2(clampi(xDiff, -tile_size, tile_size), 0))
		var next_tile_y = map_tile_set.local_to_map(position + Vector2(0, clampi(yDiff, -tile_size, tile_size)))
		
		#STEP 1, DOES THAT TILE WORK. OTHERWISE CHANGE IT AND CHECK AGAIN.
		if(abs(xDiff) >= abs(yDiff) && viableTile(next_tile_x)):
			desired_position = map_tile_set.map_to_local(next_tile_x)
		elif(abs(xDiff) < abs(yDiff) && viableTile(next_tile_y)):
			desired_position = map_tile_set.map_to_local(next_tile_y)
		elif(viableTile(next_tile_x)):
			desired_position = map_tile_set.map_to_local(next_tile_x)
		elif(viableTile(next_tile_y)):
			desired_position = map_tile_set.map_to_local(next_tile_y)
		else:
			pass
			
		##map_tile_set.get_cell_atlas_coords(tile_pos).x == 7
		#if(abs(xDiff) >= abs(yDiff)):
		#	#desired_position.x = position.x + clampi(xDiff, -tile_size, tile_size)
		#	if(xDiff < 0):
		#		pass
		#	pass
		#else:
		#	#desired_position.y = position.y + clampi(yDiff, -tile_size, tile_size)
		#	pass
		#if(map_tile_set.get_cell_atlas_coords(next_tile).x == 7):
		#	pass
		
		movement_cooldown = 0.25
	else:
		movement_cooldown -= delta

func viableTile(want_tile) -> bool:
	if(map_tile_set.get_cell_atlas_coords(want_tile).x == 7):
		return false
	return true

func moveAnimation(point : Vector2, delta : float):
	position = position.move_toward(point, 500 * delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_position = player.position
	
	#If within 1 tile of the player, initiate battle.
	if(!inFight && inCloseRange(player_position)):
		inFight = true
		player.battle(self)
		
	elif(!inFight && inRange(player_position)):
		#Move the desired position towards the player.
		move(player_position, delta)
	
	#Actually move it.
	moveAnimation(desired_position, delta)

func inCloseRange(given_player_position) -> bool:
	# Get distance from enemy to player.
	var player_distance = (given_player_position - position).abs()
	# (1 * tile_size) is just tile_size, but (1 * tile_size) is more legable meaning just 1 tile.
	if(player_distance.x <= (1 * tile_size) && player_distance.y <= (1 * tile_size)):
		return true
	return false

func inRange(given_player_position) -> bool:
	# Get distance from enemy to player.
	var player_distance = (given_player_position - position).abs()
	# Make the detection range.
	var detection_distance = tile_size * detection_range
	if(player_distance.x < detection_distance && player_distance.y < detection_distance):
		return true
	return false
