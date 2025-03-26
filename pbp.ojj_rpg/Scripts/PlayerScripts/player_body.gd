class_name Player
extends CharacterBody2D

## Variables ##
var inFight = false
var player_Class: PlayerClass

## Node Variables ##
@onready var player_animated_sprite = $PlayerAnimatedSprite
@onready var interaction_area = $InteractionArea
@onready var battle_camera = $"../BattleCamera"
@onready var player_camera = $PlayerCamera

## Battle Variables ##
var playerHP: float
var playerMana: float
var player_action_limit = 50
var player_action_amount = 0
var player_action_multiplier = 1

## Leveling Variables ##
var level = 1
var exp : int = 0
var required_exp : int = 100
var moveset := []

## Signals ##
signal health_change(new_health)
signal mana_change(new_mana)
signal action_change(new_action_amount)

## START UP ########################################################################################
func _ready() -> void:
	PlayerStats.player_node_path = get_path()
	
	#Set Player Class to what was chosen in the selection menu.
	player_Class = PlayerStats.selected_player_class
	playerHP = player_Class.getHealth()
	playerMana = player_Class.getMana()
	
	#Start Moveset
	moveset.append(null)
	moveset[0] = player_Class.getLearnset()[0]
	
	player_animated_sprite.sprite_frames = player_Class.getSpriteSet()
	
	player_action_multiplier = PlayerStats.selected_player_class.getWeaponSpeed()

## EVERY FRAME #####################################################################################
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#If not in a fight, the player can move.
	if(!inFight):
		move()
	
	elif(inFight):
		velocity = Vector2(0,0)
	
	#Check to see if there are any nearby interactables.
	checkForHighlights()
	if(Input.is_action_just_pressed("Interact")):
		checkForInteract()
	#await guard_area.ready
	#faceGuard()
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if(Input.is_key_pressed(KEY_C) && !inFight):
		var battle_scene = preload("res://Scenes/debugWorld.tscn").instantiate()
		battle_scene.z_index = 10
		battle_scene.position = player_camera.global_position
		battle_scene.readyBattle(self, [Enemy.new()])
		get_tree().root.add_child(battle_scene)
		setInFight(true)

## MOVEMENT METHODS ################################################################################
func move():
	var move_magnitude = Input.get_vector("Left","Right","Up","Down")
	velocity = move_magnitude * 250
	
	if(move_magnitude == Vector2(0,0)):
		player_animated_sprite.stop()
		player_animated_sprite.frame = 0
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

func hurt(damage_amount):
	playerHP -= damage_amount
	emit_signal("health_change", playerHP)

func manaCost(mana_cost):
	playerMana -= mana_cost
	emit_signal("mana_change", playerMana)

func actionAmountChange(change_amount):
	player_action_amount += change_amount
	emit_signal("action_change", player_action_amount)

func actionSetZero():
	player_action_amount = 0
	emit_signal("action_change", player_action_amount)

#######################Level-Related Methods#############################################

func addPlayerExperience(xp_amount : float):
	#Add experience.
	exp += xp_amount
	
	#Check for level ups.
	if (exp >= required_exp):
		levelUp()

func levelUp():
	#Increment Level Stat
	level += 1
	
	#Subtract necessary experience.
	exp = exp - required_exp
	
	#Increase next level cap.
	required_exp += 100
	
	#Check if a move can be learned.
	if player_Class.canLearnMove(level):
		moveset.append(null)
		moveset[moveset.size()-1] = player_Class.nextMove(level)
	else:
		print("No learnable move at this level.")

## Get Methods ###########################################################################

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

func canPlayerAct() -> bool:
	return getPlayerActionAmount() >= getPlayerActionLimit()
