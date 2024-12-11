class_name Inventory_Component
extends Node2D

var rows = 1
var collums = 1
var space : Array
var panel : Panel
var isPlayerInventory : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	pass

# Called with instantiated.
func _init(new_rows : int = 1, new_cols : int = 1, playerInventory : bool = false) -> void:
	rows = new_rows
	collums = new_cols
	isPlayerInventory = playerInventory
	
	#Panel / Background
	panel = Panel.new()
	panel.size = Vector2((5*(collums+1))+(64*collums), (5*(rows+1))+(64*rows))
	panel.z_index = 25
	panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	add_child(panel)
	
	for x in collums:
		space.append([])
		for y in rows:
			var new_cell = Inventory_Cell.new()
			new_cell.position = Vector2((5 * (x + 1)) + (x * 64), (5 * (y + 1)) + (y * 64))
			space[x].append(new_cell)
			add_child(new_cell)

func getWidth():
	return collums

func getLength():
	return rows

func getInventory():
	var item_array = []
	
	for x in collums:
		item_array.append([])
		for y in rows:
			item_array[x].append(space[x][y].getItem())
	
	return item_array

func setInventory(new_items, new_rows : int = rows, new_collums : int = collums):
	
	#Kill the old item_cells
	for x in collums:
		for y in rows:
			remove_child(space[x][y])
	
	#Make a new space and whatnot
	space = []
	rows = new_rows
	collums = new_collums
	
	#Make new item cells in space
	for x in collums:
		space.append([])
		for y in rows:
			var new_cell = Inventory_Cell.new()
			new_cell.position = Vector2((5 * (x + 1)) + (x * 64), (5 * (y + 1)) + (y * 64))
			space[x].append(new_cell)
			add_child(new_cell)
	
	#Give each cell a new item from the given array.
	for x in collums:
		for y in rows:
			space[x][y].setItem(new_items[x][y])

func openInventory():
	if(isPlayerInventory):
		if(self.visible):
			#These cause issues.
			PlayerStats.player_inventory = getInventory()
			self.hide()
		else:
			get_node(PlayerStats.player_node_path).inventory.setInventory(PlayerStats.player_inventory)
			self.show()
	else:
		if(self.visible):
			self.hide()
		else:
			self.show()
