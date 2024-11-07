class_name Player
extends CharacterBody2D

var player_sprite : Sprite2D
var player_collision : CollisionShape2D
var movement_cooldown = 0
var player_size : Vector2
var desired_position = position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Give the player their sprite body.
	player_sprite = Sprite2D.new()
	player_sprite.texture = load("res://Resources/dante.png")
	#  scale = 32/t
	#
	player_sprite.scale = Vector2(32.0/player_sprite.texture.get_width(), 32.0/player_sprite.texture.get_height())
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)
	moveAnimation(desired_position, delta)

func move(delta :float):
	var move_direction = Input.get_vector("Left", "Right", "Down", "Up")
	#0.707107 diagonal input
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
		movement_cooldown = 0.25
		look_at(desired_position)
	else:
		movement_cooldown -= delta

func moveAnimation(point : Vector2, delta : float):
	position = position.move_toward(point, 500 * delta)
