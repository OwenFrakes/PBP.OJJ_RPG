class_name EntityInfo
extends Control

var image_node = Sprite2D.new()
var vertical_container = VBoxContainer.new()
var health_bar_node = ProgressBar.new()
var mana_bar_node = ProgressBar.new()
var action_bar_node = ProgressBar.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	#Add Sprite First
	add_child(image_node)
	
	#VBoxContainer
	vertical_container.position = Vector2(-image_node.texture.get_size().x/2, \
										   image_node.texture.get_size().y/2)
	vertical_container.size = Vector2(128, 0)
	add_child(vertical_container)
	
	#Add the bars to the container
	vertical_container.add_child(health_bar_node)
	vertical_container.add_child(mana_bar_node)
	vertical_container.add_child(action_bar_node)

func _init(new_texture : Texture2D) -> void:
	image_node.texture = new_texture
