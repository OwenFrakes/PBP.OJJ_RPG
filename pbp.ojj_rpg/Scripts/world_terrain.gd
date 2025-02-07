extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	
	for cell in get_used_cells():
		if(get_cell_atlas_coords(cell) == Vector2i(7,2)):
			#Guardian Variable
			var all_walls = true
			#Check if the surronding cells are also walls.
			for cell_neighbor in get_surrounding_cells(cell):
				if(get_cell_atlas_coords(cell_neighbor) != Vector2i(7,2)):
					all_walls = false
			
			#If they aren't all walls. Give it collision.
			#This is an optimization feature to not make useless colliders.
			if(!all_walls):
				#Make a static body because GODOT DEMANDS IT.
				var static_body = StaticBody2D.new()
				static_body.position = map_to_local(cell)
				static_body.set_collision_mask_value(1, true)
				add_child(static_body)
				
				#Make the collision body.
				var collision_body = CollisionShape2D.new()
				collision_body.shape = RectangleShape2D.new()
				collision_body.shape.size = Vector2(64,64)
				static_body.add_child(collision_body)
				#print("WALLL")
