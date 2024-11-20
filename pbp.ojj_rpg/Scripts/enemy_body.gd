class_name EnemyBody
extends Sprite2D

#Sprite / Tile size
var tile_size = 64.0

#Variables
var desired_position = position
var movement_cooldown = 0
@onready var player = $"../Player"
var playerPosition : Vector2
var detection_range = 2
var inFight = false
var enemies = []

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
		var xDiff = playerPosition.x - position.x
		var yDiff = playerPosition.y - position.y
		
		if(abs(xDiff) >= abs(yDiff)):
			desired_position.x = position.x + clampi(xDiff, -tile_size, tile_size)
		else:
			desired_position.y = position.y + clampi(yDiff, -tile_size, tile_size)
		movement_cooldown = 0.25
	else:
		movement_cooldown -= delta

func moveAnimation(point : Vector2, delta : float):
	position = position.move_toward(point, 500 * delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	playerPosition = player.position
	
	#If within 1 tile of the player, initiate battle.
	if(!inFight && (playerPosition - position).abs() <= Vector2(tile_size,tile_size)):
		inFight = true
		player.battle(self)
	
	#If in range, chase the player to initiate battle.
	elif(!inFight && (playerPosition - position).abs() <= Vector2(tile_size * detection_range,tile_size * detection_range)):
		#Move the desired position towards the player.
		move(playerPosition, delta)
	
	#Actually move it.
	moveAnimation(desired_position, delta)
	
