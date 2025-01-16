extends Control

@onready var item_list = $Panel/ItemList
@onready var remove_button = $Panel/RemoveItemButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	item_list.item_selected.connect(activate_remove_button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(Input.is_action_just_pressed("Inventory")):
		if(self.visible == true):
			hide()
			get_tree().paused = false
		else:
			item_list.deselect_all()
			remove_button.disabled = true
			show()
			get_tree().paused = true

# Signal attached to this, AddButton.
func add_item():
	item_list.add_item("BANANA")

func remove_item():
	var selected_item = item_list.get_selected_items()
	
	if(selected_item.size() == 0):
		pass
	elif(selected_item.size() > 0):
		selected_item = selected_item[0]
		item_list.remove_item(selected_item)
		remove_button.disabled = true

func activate_remove_button(index : int):
	remove_button.disabled = false
