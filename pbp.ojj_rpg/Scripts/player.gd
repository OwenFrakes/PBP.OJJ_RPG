class_name player
extends CharacterBody2D

#Sprite / Tile size
var tile_size = 64.0

#Variables
var player_sprite : Sprite2D
var player_collision : CollisionShape2D
var movement_cooldown = 0
var player_size : Vector2
var desired_position = position
@export var picture : String
var inFight = false
@onready var main_menu_panel = $PauseMenu

#Battle Variables
@onready var battle_camera = $"../BattleCamera"
@onready var player_camera = $PlayerCamera
@onready var enemy_label = $"../BattleCamera/EnemiesLabel"
@onready var map_tile_set = $"../World Terrain"
var enemies: EnemyBody
var movePos: int
var enemyPos: int
var playerHP: float
var playerMana: float

#Leveling Variables
var level: float
var exp: float
var required_exp: float
var moveset: Array
var count: float
var check: bool

#Players Class
var player_Class: PlayerClass

## START UP ########################################################################################
func _ready() -> void:
	posToMap(position)
	
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
	player_collision = CollisionShape2D.new()
	var rectangle_shape = RectangleShape2D.new()
	var sprite_size_x = player_sprite.scale.x * player_sprite.texture.get_width()
	var sprite_size_y = player_sprite.scale.y * player_sprite.texture.get_height()
	player_size = Vector2(sprite_size_x, sprite_size_y)
	rectangle_shape.size = Vector2(sprite_size_x / 2, sprite_size_y / 2)
	player_collision.shape = rectangle_shape
	add_child(player_collision)
	
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
	
	if(Input.is_action_just_pressed("EscapeAction")):
		pauseMenu()
	
	#If not in a fight, the player can move.
	if(!inFight):
		move(delta)
	
	#Actually move the player to the desired position.
	moveAnimation(desired_position, delta)

## PAUSE MENU METHODS ##############################################################################
func pauseMenu():
	if(get_tree().paused == false):
		pauseGame()
	
	elif(get_tree().paused == true):
		resumeGame()

func mainMenu():
	resumeGame()
	get_tree().change_scene_to_file("res://Scenes/titleScreen.tscn")

func quitGame():
	resumeGame()
	get_tree().quit()

#Pauses the Game and brings up the menu.
func pauseGame():
	get_tree().paused = true
	main_menu_panel.show()

#Resumes the game and hides the menu.
func resumeGame():
	get_tree().paused = false
	main_menu_panel.hide()

func _shortcut_input(event: InputEvent) -> void:
	if (event.is_action("EscapeAction")):
		resumeGame()

## MOVEMENT METHODS ################################################################################
func move(delta : float):
	
	var tile_pos = map_tile_set.local_to_map(position)
	var move_direction = Input.get_vector("Left", "Right", "Down", "Up")
	
	if(movement_cooldown <= 0 && move_direction != Vector2(0,0)):
		match(move_direction):
			Vector2(1,0):
				tile_pos += Vector2i(1,0)
			Vector2(0,1):
				tile_pos += Vector2i(0,-1)
			Vector2(-1,0):
				tile_pos += Vector2i(-1,0)
			Vector2(0,-1):
				tile_pos += Vector2i(0,1)
		#Check what the next tile is.
		if(map_tile_set.get_cell_atlas_coords(tile_pos).x == 7):
			pass
		else:
			desired_position = map_tile_set.map_to_local(tile_pos)
			movement_cooldown = 0.25
	else:
		#Subtract time from the cooldown.
		movement_cooldown -= delta

func moveAnimation(point : Vector2, delta : float):
	#Move towards the desired position.
	position = position.move_toward(point, 500 * delta)

func posToMap(player_position : Vector2):
	var tile_pos = map_tile_set.local_to_map(player_position)
	var center_pos = map_tile_set.map_to_local(tile_pos)
	desired_position = center_pos
	position = center_pos

## BATTLE METHODS ##################################################################################
func battle(enemy_group : EnemyBody):
	PlayerStats.enemy = enemy_group
	enemies = enemy_group
	inFight = true
	battle_camera.readyBattle(enemy_group)
	switchBattleCamera()
	playerHP = player_Class.getHealth()
	playerMana = player_Class.getMana()
	
	$"../BattleCamera/Attacks/AttackList".clear()
	count = 0
	while(count < moveset.size()):
		$"../BattleCamera/Attacks/AttackList".add_item(moveset[count].getName(), null, true)
		count += 1
	
	$"../BattleCamera/Attacks/AttackList/EnemyChoice".clear()
	count = 0
	while(count < enemies.enemies.size()):
		$"../BattleCamera/Attacks/AttackList/EnemyChoice".add_item(enemies.enemies[count].getName(), null, true)
		count += 1


func battleWin():
	PlayerStats.enemy.free()
	inFight = false
	switchBattleCamera()
	exp += 20
	if exp >= required_exp:
		levelUp()

func battleLose():
	PlayerStats.enemy.free()
	inFight = false
	switchBattleCamera()

func _on_fight_btn_pressed() -> void:
	if $"../BattleCamera/Attacks".visible == false:
		$"../BattleCamera/Attacks".visible = true
	else:
		$"../BattleCamera/Attacks".visible = false

func switchBattleCamera():
	if(player_camera.is_current()):
		battle_camera.make_current()
		battle_camera.visible = true
	else:
		player_camera.make_current()
		battle_camera.visible = false

func _on_attack_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	count = 0
	
	$"../BattleCamera/Attacks/AttackList/EnemyChoice".clear()
	while(count < enemies.enemies.size()):
		$"../BattleCamera/Attacks/AttackList/EnemyChoice".add_item(enemies.enemies[count].getName(), null, true)
		count += 1
	
	$"../BattleCamera/Attacks/AttackList/EnemyChoice".visible = true
	while(count<moveset.size()):
		if(moveset[count].getName() == $"../BattleCamera/Attacks/AttackList".get_item_text(count)):
			print("found")
			movePos = count
			break
		else:
			count += 1

func _on_enemy_choice_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	enemyPos = index
	if enemies.enemies.size() >= 0:
		count = 0
		while (count <= enemies.enemies.size()):
			enemyAttack(count)
			count += 1
	playerAttack()
	$"../BattleCamera/Attacks".visible = false
	$"../BattleCamera/Attacks/AttackList/EnemyChoice".visible = false

func playerAttack():
	var enemyHP = enemies.enemies[enemyPos].getHealth()
	enemyHP -= moveset[movePos].getDamage() * getPlayerAttackEffectiveness()
	enemies.enemies[enemyPos].health = enemyHP
	playerHP -= moveset[movePos].getHealthCost()
	playerMana -= moveset[movePos].getManaCost()
	if enemyHP <= 0:
		enemies.enemies.remove_at(enemyPos)
		$"../BattleCamera/PlayerLabel".text = "Player: \n"
		$"../BattleCamera/PlayerLabel".text += (str(player_Class.getName()) + "\n" + str(playerHP) + "\n" +  str(player_Class.getStamina()) + "\n" + str(player_Class.getMana()))
		$"../BattleCamera/EnemiesLabel".text = "Enemies: \n"
		count = 0 
		for enemy in enemies.enemies:
			$"../BattleCamera/EnemiesLabel".text += (enemy.stringInfo())
	if enemies.enemies.size() == 0:
		battleWin()
		


func enemyAttack(enemyLoc: int):
	var tempAttack = getEnemyAttack(enemyLoc)
	playerHP -= tempAttack.getDamage() * getEnemyAttackEffectiveness(tempAttack.getType(), enemyLoc)

#this local variable of enemyPos is being fed an int from enemyAttack()
func getEnemyAttack(enemyLoc: int):
	count = 0
	var weakCount = 0
	#for each of the players weaknesses, check if an enemy move matches typing.
	while(weakCount < player_Class.getWeakness().size()):
		#for each move of the selected enemy
		while(count < enemies.enemies[enemyLoc].moveset.size()):
			#If an enemy's move matches a player weakness, return that move. Else iterate
			if enemies.enemies[enemyLoc].moveset[count].getType() == player_Class.getWeakness()[weakCount]:
				return enemies.enemies[enemyLoc].moveset[count]
			else:
				count += 1
		weakCount += 1
	return enemies.enemies[enemyLoc].moveset[0]


func getEnemyAttackEffectiveness(attackType: String, enemyLoc: int):
	count = 0
	var weakCount = 0
	#for each of the players weaknesses, check if an enemy move matches typing.
	while(weakCount < player_Class.getWeakness().size()):
		#for each move of the selected enemy
		while(count < enemies.enemies[enemyLoc].moveset.size()):
			#If an enemy's move matches a player weakness, return that move. Else iterate
			if enemies.enemies[enemyLoc].moveset[count].getType() == player_Class.getWeakness()[weakCount]:
				return 2
			else:
				count += 1
		weakCount += 1
	return 1

func getPlayerAttackEffectiveness():
	count = 0
	while(count < enemies.enemies[enemyPos].weakness.size()):
		if(moveset[movePos].getType() == enemies.enemies[enemyPos].getWeakness(count)):
			return 2
			break
		else:
			count += 1
	return 1

## LEVELING METHODS ##################################################################################
func levelUp():
	level += 1
	exp = exp - required_exp
	required_exp += 100
	if level == player_Class.getLearnset()[count].getLearnLevel():
		moveset.append(attack.new())
		moveset[count] = player_Class.getLearnset()[count]
		count += 1
	
