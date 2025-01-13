class_name Inventory_Cell
extends Node2D

var item = null
var button : Button
@onready var player = get_node(PlayerStats.player_node_path)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button = Button.new()
	button.size = Vector2(64,64)
	add_child(button)
	
	button.pressed.connect(active_cell)
	z_index = 50

func _init(new_item = null) -> void:
	item = new_item
	if(typeof(item) != typeof(null)):
		button.icon = item.item_icon
		button.text = "Worked"

func active_cell():
	#Player has nothing selected
	if(typeof(player.active_inventory_cell) == typeof(null)):
		player.active_inventory_cell = self
		button.self_modulate = Color(0,1,0)
	#Player has the same cell selected
	elif(player.active_inventory_cell == self):
		player.active_inventory_cell = null
		button.self_modulate = Color(1,1,1)
	#Player selected a different cell
	else:
		player.active_inventory_cell.button.self_modulate = Color(1,1,1)
		var old_item = item
		setItem(player.active_inventory_cell.item)
		player.active_inventory_cell.setItem(old_item)
		player.active_inventory_cell = null

func setItem(new_item : Item_Base):
	item = new_item
	if(typeof(item) == typeof(null)):
		button.text = ""
	else:
		button.text = item.getName()

func getItem():
	if(typeof(item) == typeof(null)):
		return null
	return item
