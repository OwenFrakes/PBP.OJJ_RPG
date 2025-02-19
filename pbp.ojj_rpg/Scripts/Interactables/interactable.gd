class_name Interactable
extends StaticBody2D

var collision_body : CollisionShape2D
var highlighted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_body = CollisionShape2D.new()
	collision_body.shape = CircleShape2D.new()
	collision_body.shape.radius = 32
	add_child(collision_body)
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)

func interact():
	print("INTERACTED YEAHHHHHHH")

func highlight(boolean : bool):
	if(boolean):
		highlighted = true
		modulate = Color(0.6,1,0.6)
	else:
		highlighted = false
		modulate = Color(1,1,1)
