class_name ItemMaster
extends Node

@onready var item_list_reference
@onready var player_reference

func _ready() -> void:
	#item_list_reference = get_node(PlayerStats.player_item_list)
	#player_reference = get_node(PlayerStats.player_node_path)
	pass

func find_item(item_name : String):
	item_name = item_name.to_lower()
	if(item_name.match("")):
		print("Error: No Item Name - item_master.gd")
	else:
		var selected_item = item_list_reference.get_selected_items()[0]
		item_list_reference.remove_item(selected_item)
		match(item_name):
			"banana":
				print("ANANAAAAA")
				player_reference.player_animated_sprite.modulate = Color(0,1,0)
