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

#Leveling Variables
var level: float
var exp: float
var required_exp: float
var moveset: Array
var count: float
var check: bool

#Battle Variables
@onready var battle_camera = $"../BattleCamera"
@onready var player_camera = $PlayerCamera
@onready var enemy_label = $"../BattleCamera/EnemiesLabel"
var enemies: EnemyBody
var movePos: int
var enemyPos: int
var playerHP: float
var playerMana: float

#Players Class
var player_Class: PlayerClass

## START UP ########################################################################################
func _ready() -> void:
	
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
	
	#Add Class to Player
	player_Class = PlayerClass.new()
	player_Class.setClass(PlayerStats.selected_player_class.getName(), \
						PlayerStats.selected_player_class.getHealth(), \
						PlayerStats.selected_player_class.getStamina(), \
						PlayerStats.selected_player_class.getMana(), \
						PlayerStats.selected_player_weapon.getName(), \
						PlayerStats.selected_player_weapon.getDamage(), \
						PlayerStats.selected_player_weapon.getAttackSpeed(), \
						PlayerStats.selected_player_weapon.getType(), \
						PlayerStats.selected_player_class.getWeakness())
	
	#Start Moveset
	count = 0 
	moveset.resize(0)
	moveset.append(attack.new())
	moveset[count] = player_Class.getLearnset()[count]
	count += 1
	

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
	playerHP = player_Class.getHealth()
	playerMana = player_Class.getMana()

func setInFight(boolean: bool):
	if(boolean):
		inFight = true
	else:
		inFight = false

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

#######################Level-Related Methods#############################################

func levelUp():
	level += 1
	exp = exp - required_exp
	required_exp += 100
	if level == player_Class.getLearnset()[count].getLearnLevel():
		moveset.append(attack.new())
		moveset[count] = player_Class.getLearnset()[count]
		count += 1

func addPlayerExperience(xp_amount : float):
	exp += xp_amount
	if (exp >= required_exp):
		levelUp()

func getPlayerMoveset():
	return moveset

func getPlayerHealth():
	return playerHP

func getPlayerMana():
	return playerMana

func getPlayerClass():
	return player_Class
