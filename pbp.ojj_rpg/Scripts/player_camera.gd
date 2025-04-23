extends Node2D

var mouse_position
var player_ref

# max is the maxium distance the camera can be from the player.
# slope is a variable used in calculation.
var x_max = 200.0
var x_slope = x_max/960.0

var y_max = 250.0
var y_slope = y_max/540.0


func _process(delta: float) -> void:
	mouse_position = get_viewport().get_mouse_position()
	player_ref = get_parent()
	
	var x_rotation_limit = abs(cos(Vector2(960, 540).angle_to_point(mouse_position)))
	var y_rotation_limit = abs(sin(Vector2(960, 540).angle_to_point(mouse_position)))
	
	# These are very specific formulas,
	# please don't change them unless you know what you're doing.
	position.x = ((mouse_position.x * x_slope) - x_max) * x_rotation_limit
	position.y = ((mouse_position.y * y_slope) - y_max) * y_rotation_limit
	if Input.is_action_just_pressed("DEBUG"):
		print(str(x_rotation_limit) + "X")
		print(str(y_rotation_limit) + "Y")
