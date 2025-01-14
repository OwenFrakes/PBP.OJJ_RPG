extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_constant_torque(100000)
	
	while(true):
		await get_tree().create_timer(1).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
