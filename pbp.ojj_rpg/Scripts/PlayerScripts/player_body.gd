class_name Player
extends CharacterBody2D

#Sprite / Tile size
var tile_size = 64.0

#Variables
@onready var player_animated_sprite = $PlayerAnimatedSprite
var player_size : Vector2
var desired_position = position
@export var picture : String
var inFight = false
@onready var interaction_area = $InteractionArea

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
var movePos: int
var enemyPos: int
var playerHP: float
var playerMana: float
var player_action_limit = 50
var player_action_amount = 0
var player_action_multiplier = 1

#Players Class
var player_Class: PlayerClass

## START UP ########################################################################################
func _ready() -> void:
	PlayerStats.player_node_path = get_path()
	##Give the player their sprite body.
	#player_sprite = Sprite2D.new()
	#player_sprite.texture = load(picture)
	## The size of each picture will be 32x32 pixels.
	## Scale will be changed to make the size of the picture so. Where scale is : scale = 32/t
	#player_sprite.scale = Vector2(tile_size/player_sprite.texture.get_width(), \
	#							  tile_size/player_sprite.texture.get_height())
	#player_sprite.z_index = 5
	#add_child(player_sprite)
	
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
						PlayerStats.selected_player_class.getWeakness(), \
						PlayerStats.selected_player_class.getSpriteSet())
	
	#Start Moveset
	count = 0 
	moveset.resize(0)
	moveset.append(attack.new())
	moveset[count] = player_Class.getLearnset()[count]
	count += 1
	
	player_animated_sprite.sprite_frames = player_Class.getSpriteSet()
	
	player_action_multiplier = PlayerStats.selected_player_class.getWeaponSpeed()

## EVERY FRAME #####################################################################################
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#If not in a fight, the player can move.
	if(!inFight):
		move()
	
	elif(inFight):
		velocity = Vector2(0,0)
	
	#Check to see if there are any nearby interactables.
	checkForHighlights()
	if(Input.is_action_just_pressed("Interact")):
		checkForInteract()
	
	move_and_slide()

## MOVEMENT METHODS ################################################################################
func move():
	var move_magnitude = Input.get_vector("Left","Right","Up","Down")
	velocity = move_magnitude * 250
	
	if(move_magnitude == Vector2(0,0)):
		player_animated_sprite.play("idle")
	else:
		player_animated_sprite.play()
		match(move_magnitude):
			Vector2(1,0): ## Moving Right
				if(!(player_animated_sprite.animation == "walking_right")):
					player_animated_sprite.play("walking_right")
			Vector2(-1,0): ## Moving Left
				if(!(player_animated_sprite.animation == "walking_left")):
					player_animated_sprite.play("walking_left")
			Vector2(0,1): ## Moving Down
				if(!(player_animated_sprite.animation == "walking_down")):
					player_animated_sprite.play("walking_down")
			Vector2(0,-1): ## Moving Up
				if(!(player_animated_sprite.animation == "walking_up")):
					player_animated_sprite.play("walking_up")

## Interaction #####################################################################################
var dehighlights = []
func checkForHighlights():
	var bodies = interaction_area.get_overlapping_bodies()
	
	for body in bodies:
		if(body is Interactable):
			body.highlight(true)
	
	#Check each body for a potential de-highlight.
	for old_body in dehighlights:
		#Guardian variable for next for statement.
		var still_here = false
		
		#Iterate each body currently in the player's reach
		for current_body in bodies:
			#If a potenial dehighlight matches a body in the player's reach, 
			#change the guardian variable, and break the loop for efficiency.
			if(old_body == current_body):
				still_here = true
				break
		
		#If the body matches no current bodies, dehighlight it.
		if(!still_here):
			old_body.highlight(false)
	
	dehighlights = bodies

func checkForInteract():
	var bodies = interaction_area.get_overlapping_bodies()
	
	for body in bodies:
		if(body is Interactable):
			body.interact()

## BATTLE METHODS ##################################################################################
func battle(enemy_group):
	PlayerStats.enemy = enemy_group
	inFight = true
	set_collision_mask_value(2, false)
	switchBattleCamera(true)
	playerHP = player_Class.getHealth()
	playerMana = player_Class.getMana()
	battle_camera.readyBattle(enemy_group)

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
	battleWin()

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

func getPlayerActionLimit():
	return player_action_limit

func getPlayerActionAmount():
	return player_action_amount

func getPlayerActionMultiplier():
	return player_action_multiplier
