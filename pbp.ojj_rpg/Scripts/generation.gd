extends TileMapLayer

@export var size : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#set_cell(position in the tileMap's grid, tileSet ID, position in tileSet from ID)
	
	for x in range(size):
		for y in range(size):
			set_cell(Vector2(x,y), 0, Vector2i(0,randi_range(0,1)))
	
	for x in range(8):
		#await get_tree().create_timer(0.5).timeout
		conway()

func conway():
	var newMap = []
	for x in size:
		newMap.append([])
		for y in size:
			newMap[x].append(0)
	
	var white = 0
	for x in range(size):
		white = 0
		for y in range(size):
			#Set to zero
			white = 0
			
			#Get the surrounding cells
			var cells = squareCells(x,y)
			for pos in cells:
				#Count the colors
				if(get_cell_atlas_coords(pos) == Vector2i(0,1)):
					white += 1
			
			#Change the cell on the new map
			if(get_cell_atlas_coords(Vector2i(x,y)) == Vector2i(0,1) && white > 3):
				newMap[x][y] = 1
				#pass
			elif(get_cell_atlas_coords(Vector2i(x,y)) == Vector2i(0,0) && white > 4):
				newMap[x][y] = 1
				#set_cell(Vector2i(x+1,y+1), 1, Vector2i(0,0))
			else:
				newMap[x][y] = 0
				#set_cell(Vector2i(x+1,y+1), 0, Vector2i(0,0))
	
	for x in range(size):
		for y in range(size):
			if(newMap[x][y] == 1):
				set_cell(Vector2(x,y), 0, Vector2i(0,1))
			else:
				set_cell(Vector2(x,y), 0, Vector2i(0,0))

func squareCells(x : int, y : int):
	var surroundingCells = []
	
	for xCord in range(3):
		for yCord in range(3):
			surroundingCells.append(Vector2i((x-1) + xCord, (y-1) + yCord))
	surroundingCells.erase(Vector2i(x,y))
	
	return surroundingCells

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#set_cell(local_to_map(get_global_mouse_position()), 1, Vector2i(0,0))
	pass
