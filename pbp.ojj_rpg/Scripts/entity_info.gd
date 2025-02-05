class_name EntityInfo
extends Control

var label_node = Label.new()
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
	
	#Other Node edits.
	label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	health_bar_node.self_modulate = Color(1,0,0)
	action_bar_node.self_modulate = Color(0,1,0)
	
	#Add the bars to the container
	vertical_container.add_child(label_node)
	vertical_container.add_child(health_bar_node)
	vertical_container.add_child(mana_bar_node)
	vertical_container.add_child(action_bar_node)

func _init(new_label : String, new_texture : Texture2D = load("res://Resources/icon.svg")) -> void:
	image_node.texture = new_texture
	label_node.text = new_label

func isEnemy():
	mana_bar_node.hide()

##Health##
func setHealthBar(new_max, current_value = new_max):
	health_bar_node.max_value = new_max
	health_bar_node.value = current_value

func changeHealth(new_value):
	health_bar_node.value = new_value

##Mana##
func setManaBar(new_max, current_value = new_max):
	mana_bar_node.max_value = new_max
	mana_bar_node.value = current_value

func changeMana(new_value):
	mana_bar_node.value = new_value

##Action##
func setActionBar(new_max, current_value = 0):
	action_bar_node.max_value = new_max
	action_bar_node.value = current_value

func changeAction(new_value):
	action_bar_node.value = new_value
