extends RigidBody2D

@onready var player_reference = $"../Player"
var player_position : Vector2
var move_cooldown = 0
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
		if body is Player:
			player_reference.battle(enemies)
			get_tree().paused = true
	
	#If infight, then can't move.
	if(!inFight):
		#How far the enemy is from the player.
		var player_distance = (player_position - position).abs()
		
		#If within hopping distance, hop.
		if((player_distance.x < 500 && player_distance.y < 500) && move_cooldown <= 0):
			apply_impulse((player_position - position) * 2)
			move_cooldown = 3
		else:
			move_cooldown -= delta
	
	
