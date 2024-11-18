class_name EnemyBody
extends Sprite2D

var desired_position = position
var movement_cooldown = 0
@onready var player = $"../Player"
var playerPosition : Vector2
var range = 8
var inFight = false
var enemies = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var posX = ((int(position.x) / 32) * 32) + 16
	var posY = ((int(position.y) / 32) * 32) + 16
	position = Vector2(posX, posY)
	desired_position = Vector2(posX, posY)
	
	scale = Vector2(32.0/texture.get_width(), 32.0/texture.get_height())
	
	enemies.append(Enemy.new())

func move(point : Vector2, delta : float):
	if(movement_cooldown <= 0):
		#Get wether the enemy is farther from the player in the y or x dimension.
		var xDiff = playerPosition.x - position.x
		var yDiff = playerPosition.y - position.y
		
		if(abs(xDiff) >= abs(yDiff)):
			desired_position.x = position.x + clampi(xDiff, -32, 32)
		else:
			desired_position.y = position.y + clampi(yDiff, -32, 32)
		movement_cooldown = 0.25
	else:
		movement_cooldown -= delta

func moveAnimation(point : Vector2, delta : float):
	position = position.move_toward(point, 500 * delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	playerPosition = player.position
	
	#If within 1 tile of the player, initiate battle.
	if(!inFight && (playerPosition - position).abs() <= Vector2(32,32)):
		inFight = true
		player.battle(self)
	
	#If in range, chase the player to initiate battle.
	elif(!inFight && (playerPosition - position).abs() <= Vector2(32 * range,32 * range)):
		#Move the desired position towards the player.
		move(playerPosition, delta)
	
	#Actually move it.
	moveAnimation(desired_position, delta)
	
