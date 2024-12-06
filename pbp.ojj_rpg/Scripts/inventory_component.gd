class_name Inventory_Component
extends Node2D

var rows = 1
var collums = 1
var space : Array
var panel : Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called with instantiated.
func _init(new_rows : int = 1, new_cols : int = 1) -> void:
	rows = new_rows
	collums = new_cols
	
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
	

func openInventory():
	if(self.visible):
		self.hide()
	else:
		self.show()
