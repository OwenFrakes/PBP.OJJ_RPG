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

func _init(new_item = null) -> void:
	item = new_item
	if(typeof(item) != typeof(null)):
		button.icon = item.item_icon
		button.text = "Worked"

func active_cell():
	player.active_inventory_cell = self
	print(player.active_inventory_cell.getItem())

func setItem(new_item : Item_Base):
	item = new_item
	#Issue here, button dosen exist yet or something

func getItem():
	if(typeof(item) == typeof(null)):
		return "Empty"
	return item
