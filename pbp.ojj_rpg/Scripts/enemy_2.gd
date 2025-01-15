extends RigidBody2D

@onready var player_reference = $"../Player"
var player_position : Vector2
var move_cooldown = 0
var inFight = false
var enemies = []
var leap_power = 1.25

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
		if body is Player and !inFight:
			player_reference.battle(self)
			inFight = true
	
	#If infight, then can't move.
	if(!inFight):
		#How far the enemy is from the player.
		var player_distance_vector = (player_position - position).abs()
		var player_distance = sqrt(pow(player_distance_vector.x, 2) + pow(player_distance_vector.y, 2))
		
		#If within hopping distance, hop.
		if((player_distance < 1000) && move_cooldown <= 0):
			#If close, do a short hop.
			if(player_distance < 400):
				var jump_power_long = (((-1.0 / (10.0/3.0)) * (player_distance/100.0)) + 3.0)
				apply_impulse((player_position - position) * jump_power_long)
				print(jump_power_long)
				move_cooldown = 0.75
			#If far, do a long hop.
			else:
				var jump_power_short = (((-1.0 / (10.0/3.0)) * (player_distance/100.0)) + 3.0)
				apply_impulse((player_position - position) * jump_power_short)
				print(jump_power_short)
				move_cooldown = 1.75
		else:
			move_cooldown -= delta
	
	
