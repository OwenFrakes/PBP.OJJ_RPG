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

func openInventory():
	if(isPlayerInventory):
		if(self.visible):
			#These cause issues.
			PlayerStats.player_inventory = get_node(PlayerStats.player_node_path).inventory
			self.hide()
		else:
			get_node(PlayerStats.player_node_path).inventory = PlayerStats.player_inventory
			self.show()
	else:
		if(self.visible):
			self.hide()
		else:
			self.show()
