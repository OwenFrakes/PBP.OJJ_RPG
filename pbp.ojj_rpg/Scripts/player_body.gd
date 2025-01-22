class_name Player
extends CharacterBody2D

#Sprite / Tile size
var tile_size = 64.0

#Variables
var player_sprite : Sprite2D
var player_collision : CollisionShape2D
var player_size : Vector2
var desired_position = position
@export var picture : String
var inFight = false

#Battle Variables
@onready var battle_camera = $"../BattleCamera"
@onready var player_camera = $PlayerCamera
@onready var enemy_label = $"../BattleCamera/EnemiesLabel"

## START UP ########################################################################################
func _ready() -> void:
	PlayerStats.player_node_path = get_path()
	
	#Give the player their sprite body.
	player_sprite = Sprite2D.new()
	player_sprite.texture = load(picture)
	# The size of each picture will be 32x32 pixels.
	# Scale will be changed to make the size of the picture so. Where scale is : scale = 32/t
	player_sprite.scale = Vector2(tile_size/player_sprite.texture.get_width(), \
								  tile_size/player_sprite.texture.get_height())
	player_sprite.z_index = 5
	add_child(player_sprite)
	
	#Give the player their collisions.
	#player_collision = CollisionShape2D.new()
	#var rectangle_shape = RectangleShape2D.new()
	#var sprite_size_x = player_sprite.scale.x * player_sprite.texture.get_width()
	#var sprite_size_y = player_sprite.scale.y * player_sprite.texture.get_height()
	#player_size = Vector2(sprite_size_x, sprite_size_y)
	#rectangle_shape.size = Vector2(sprite_size_x / 2, sprite_size_y / 2)
	#player_collision.shape = rectangle_shape
	#add_child(player_collision)
	

## EVERY FRAME #####################################################################################
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#If not in a fight, the player can move.
	if(!inFight):
		move()
	
	elif(inFight):
		velocity = Vector2(0,0)
	
	#Actually move the player to the desired position.
	#moveAnimation(desired_position, delta)
	
	move_and_slide()

## MOVEMENT METHODS ################################################################################
func move():
	var move_magnitude = Input.get_vector("Left","Right","Up","Down")
	velocity = move_magnitude * 250

## BATTLE METHODS ##################################################################################
func battle(enemy_group):
	PlayerStats.enemy = enemy_group
	inFight = true
	battle_camera.readyBattle(enemy_group)
	set_collision_mask_value(2, false)
	switchBattleCamera(true)

func battleWin():
	PlayerStats.enemy.free()
	inFight = false
	switchBattleCamera(false)
	set_collision_mask_value(2, true)

func battleLose():
	get_tree().quit()

func switchBattleCamera(battle_cam_yes : bool):
	if(battle_cam_yes):
		battle_camera.make_current()
		battle_camera.visible = true
	else:
		player_camera.make_current()
		battle_camera.visible = false
