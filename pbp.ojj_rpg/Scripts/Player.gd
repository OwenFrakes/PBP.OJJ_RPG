class_name Player
extends CharacterBody2D

#Variables
var player_sprite : Sprite2D
var player_collision : CollisionShape2D
var movement_cooldown = 0
var player_size : Vector2
var desired_position = position
@export var picture : String
var inFight = false

#SRUFF
@onready var battle_camera = $"../BattleCamera"
@onready var player_camera = $PlayerCamera
@onready var enemy_label = $"../BattleCamera/Control/SubViewportContainer/SubViewport/EnemiesLabel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Make sure the player object center is in the middle of the 32 by 32 pixel grid.
	var posX = ((int(position.x) / 32) * 32) + 16
	var posY = ((int(position.y) / 32) * 32) + 16
	position = Vector2(posX, posY)
	desired_position = Vector2(posX, posY)
	
	#Give the player their sprite body.
	player_sprite = Sprite2D.new()
	player_sprite.texture = load(picture)
	# The size of each picture will be 32x32 pixels.
	# Scale will be changed to make the size of the picture so. Where scale is : scale = 32/t
	player_sprite.scale = Vector2(32.0/player_sprite.texture.get_width(), 32.0/player_sprite.texture.get_height())
	player_sprite.z_index = 5
	#player_sprite.rotate(PI*3/2)
	add_child(player_sprite)
	
	#Give the player their collisions.
	player_collision = CollisionShape2D.new()
	var rectangle_shape = RectangleShape2D.new()
	var sprite_size_x = player_sprite.scale.x * player_sprite.texture.get_width()
	var sprite_size_y = player_sprite.scale.y * player_sprite.texture.get_height()
	player_size = Vector2(sprite_size_x, sprite_size_y)
	rectangle_shape.size = Vector2(sprite_size_x / 2, sprite_size_y / 2)
	player_collision.shape = rectangle_shape
	add_child(player_collision)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#If not in a fight, the player can move.
	if(!inFight):
		move(delta)
	
	
	#Actually move the player to the desired position.
	moveAnimation(desired_position, delta)

func move(delta :float):
	# Get which way is the player moving.
	var move_direction = Input.get_vector("Left", "Right", "Down", "Up")
	#0.707107 for diagonal input. Probably doesn't matter though.
	
	#The player can move if they aren't on cooldown.
	#The 2nd If is so it doesn't try moving while the player isn't trying to move.
	if(movement_cooldown <= 0 && move_direction != Vector2(0,0)):
		match(move_direction):
			#Left
			Vector2(-1,0):
				desired_position.x -= player_size.x
			#Right
			Vector2(1,0):
				desired_position.x += player_size.x 
			#Down
			Vector2(0,-1):
				desired_position.y += player_size.y 
			#Up
			Vector2(0,1):
				desired_position.y -= player_size.y 
		
		#Stop the player from moving instantly again.
		movement_cooldown = 0.25
		
		#Face the direction they're moving.
		player_sprite.look_at(desired_position)
		player_sprite.rotate(-PI/2)
	else:
		#Subtract time from the cooldown.
		movement_cooldown -= delta

func moveAnimation(point : Vector2, delta : float):
	#Move towards the desired position.
	position = position.move_toward(point, 500 * delta)

func battle(enemy_group):
	PlayerStats.enemy = enemy_group
	inFight = true
	
	var enemies = enemy_group.enemies
	
	for enemy in enemies:
		enemy_label.text += str(enemy.title + "\n")
		enemy_label.text += str(str(enemy.health) + "\n")
		enemy_label.text += str(str(enemy.something) + "\n")
		enemy_label.text += str(enemy.rizz)
	
	switchBattleCamera()

func battleWin():
	PlayerStats.enemy.free()
	inFight = false
	switchBattleCamera()

func battleLose():
	get_tree().quit()

func switchBattleCamera():
	if(player_camera.is_current()):
		battle_camera.make_current()
		battle_camera.visible = true
	else:
		player_camera.make_current()
		battle_camera.visible = false
