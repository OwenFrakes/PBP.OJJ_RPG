extends RigidBody2D

@onready var player_reference = $"../Player"
var player_position : Vector2
var move_cooldown = 0.0
var inFight = false
var enemies = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Needed for get_colliding_bodies
	contact_monitor = true
	max_contacts_reported = 5
	
	enemies.append(Enemy.new())
	enemies.append(Enemy.new())
	enemies.append(Enemy.new())


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
	
	
