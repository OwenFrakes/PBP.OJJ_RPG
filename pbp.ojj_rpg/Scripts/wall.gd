class_name Wall
extends MeshInstance2D

var static_body_node
var collision_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	static_body_node = StaticBody2D.new()
	add_child(static_body_node)
	
	var collision_size_x = mesh.size.x 
	var collision_size_y = mesh.size.y 
	
	collision_node = CollisionShape2D.new()
	collision_node.shape = RectangleShape2D.new()
	collision_node.shape.size = Vector2(collision_size_x, collision_size_y)
	static_body_node.add_child(collision_node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
