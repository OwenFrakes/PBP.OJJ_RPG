extends Control

@onready var item_list = $Panel/ItemList
@onready var remove_button = $Panel/ButtonContainer/RemoveItemButton
@onready var use_button = $Panel/ButtonContainer/UseButton
var item_master = ItemMaster.new()
@onready var player_reference = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	item_list.item_selected.connect(activate_buttons)
	add_child(item_master)
	item_master.item_list_reference = item_list
	item_master.player_reference = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(Input.is_action_just_pressed("Inventory") && !player_reference.inFight):
		print("Byapss")
		if(self.visible == true):
			hide()
			get_tree().paused = false
		else:
			item_list.deselect_all()
			remove_button.disabled = true
			use_button.disabled = true
			show()
			get_tree().paused = true

# Signal attached to this, AddButton.
func add_item():
	item_list.add_item("BANANA")

func use_item():
	# Get the selected Item's name
	var item_name = item_list.get_item_text(item_list.get_selected_items()[0])
	use_button.disabled = true
	
	# Make the item master and have it work its magic.
	item_master.find_item(item_name)

func remove_item():
	var selected_item = item_list.get_selected_items()
	
	if(selected_item.size() == 0):
		pass
	elif(selected_item.size() > 0):
		selected_item = selected_item[0]
		item_list.remove_item(selected_item)
		remove_button.disabled = true

func activate_buttons(index : int):
	use_button.disabled = false
	remove_button.disabled = false
