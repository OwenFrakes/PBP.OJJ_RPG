class_name EnemyBody
extends RigidBody2D

@onready var player_reference
var player_position : Vector2
var move_cooldown = 0.0
var inFight = false
var enemies = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Needed for get_colliding_bodies
	contact_monitor = true
	max_contacts_reported = 5
	
	#Make the enemies' moveset
	var moveset = []
	moveset.resize(4)
	moveset[0] = attack.new()
	moveset[0].setAttack("Basic Attack", 10, 0, 0, "pierce", 0)
	moveset[1] = attack.new()
	moveset[1].setAttack("Basic Fire", 10, 0, 2, "fire", 0)
	moveset[2] = attack.new()
	moveset[2].setAttack("Basic Light", 10, 0, 2, "light", 0)
	moveset[3] = attack.new()
	moveset[3].setAttack("Basic Dark", 10, 0, 0, "dark", 0)
	
	#Make the enemies and set them up.
	enemies.append(Enemy.new())
	enemies[0].setEnemy("ma,e", 40 * randi_range(1,3), 20, ["fire, ice"], moveset)
	enemies.append(Enemy.new())
	enemies[1].setEnemy("goku", 40 * randi_range(1,3), 20, ["fire, ice"], moveset)
	enemies.append(Enemy.new())
	enemies[2].setEnemy("dante", 40 * randi_range(1,3), 20, ["fire, ice"], moveset)
	
	player_reference = get_tree().root.get_node(PlayerStats.player_node_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#get the player's current position for this process
	player_position = player_reference.position
	
	#Get bodies touching this one.
	var collisions = get_colliding_bodies()
	
	#If the player is touching, do stuff.
	for body in collisions:
		if (body is Player) and (!inFight && !player_reference.inFight):
			player_reference.battle(self)
			inFight = true
		elif body is Player and player_reference.inFight:
			apply_central_impulse((position - player_position) * 5)
	
	#If infight, then can't move.
	if(!inFight && !player_reference.inFight):
		#How far the enemy is from the player.
		var player_distance_vector = (player_position - position).abs()
		var player_distance = sqrt(pow(player_distance_vector.x, 2) + pow(player_distance_vector.y, 2))
		
		#If within hopping distance, and not on cooldown, hop.
		if(player_distance < 1000 && move_cooldown <= 0):
			#Calculate the jump power. Fun equation to read in code.
			var jump_power = (((-1.0 / (10.0/3.0)) * (player_distance/100.0)) + 3.0) + randf_range(-0.5, 0.5)
			#print(jump_power)
			
			#If close, do a short hop.
			if(player_distance < 400):
				apply_impulse((player_position - position) * jump_power)
				move_cooldown = 0.75
			
			#If far, do a long hop.
			else:
				apply_impulse((player_position - position) * jump_power)
				move_cooldown = 1.75
		
		#If outside range, or on cooldown, remove time from the cool down timer.
		else:
			move_cooldown -= delta
	
	
