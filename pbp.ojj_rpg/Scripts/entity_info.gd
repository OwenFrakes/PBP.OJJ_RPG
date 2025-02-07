class_name EntityInfo
extends Control

var image_node = AnimatedSprite2D.new()
var vertical_container = VBoxContainer.new()
var name_label_node = Label.new()
var health_bar_node = ProgressBar.new()
var health_label_node = Label.new()
var mana_bar_node = ProgressBar.new()
var mana_label_node = Label.new()
var action_bar_node = ProgressBar.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	texture_filter = TEXTURE_FILTER_NEAREST
	
	#Add Sprite First
	add_child(image_node)
	image_node.scale = Vector2(2,2)
	
	#VBoxContainer
	vertical_container.size = Vector2(image_node.sprite_frames.get_frame_texture("default", 0).get_size().x * 2, 10)
	vertical_container.position = Vector2(-image_node.sprite_frames.get_frame_texture("default", 0).get_size().x, \
										   image_node.sprite_frames.get_frame_texture("default", 0).get_size().y)
	add_child(vertical_container)
	
	#Other Node edits.
	name_label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	health_label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mana_label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	health_bar_node.self_modulate = Color(1,0,0)
	health_bar_node.show_percentage = false
	health_bar_node.custom_minimum_size = Vector2(0,20)
	health_label_node.self_modulate = Color(1,0,0)
	
	mana_bar_node.self_modulate = Color(0,0,1)
	mana_bar_node.show_percentage = false
	mana_bar_node.custom_minimum_size = Vector2(0,20)
	mana_label_node.self_modulate = Color(0,0,1)
	
	action_bar_node.self_modulate = Color(0,1,0)
	
	###Add the bars to the container###
	#Name
	vertical_container.add_child(name_label_node)
	#Health
	vertical_container.add_child(health_bar_node)
	vertical_container.add_child(health_label_node)
	#Mana
	vertical_container.add_child(mana_bar_node)
	vertical_container.add_child(mana_label_node)
	#Action
	vertical_container.add_child(action_bar_node)
	

func _init(new_label : String, new_texture : SpriteFrames = load("res://Resources/Character/SpriteSets/blue_robot_set.tres")) -> void:
	image_node.sprite_frames = new_texture
	image_node.stop()
	image_node.frame = 0
	name_label_node.text = new_label

func isEnemy():
	mana_bar_node.hide()
	mana_label_node.hide()

##Health###################################################
func setHealthBar(new_max, current_value = new_max):
	health_bar_node.max_value = new_max
	health_bar_node.value = current_value
	
	health_label_node.text = "Health: " + str(current_value) + "/" + str(new_max)

func changeHealth(new_value):
	health_bar_node.value = new_value
	health_label_node.text = "Mana: " + str(new_value) + "/" + str(health_bar_node.max_value)

##Mana###################################################
func setManaBar(new_max, current_value = new_max):
	mana_bar_node.max_value = new_max
	mana_bar_node.value = current_value
	
	mana_label_node.text = "Mana: " + str(current_value) + "/" + str(new_max)

func changeMana(new_value):
	mana_bar_node.value = new_value
	mana_label_node.text = "Mana: " + str(new_value) + "/" + str(mana_bar_node.max_value)

##Action###################################################
func setActionBar(new_max, current_value = 0):
	action_bar_node.max_value = new_max
	action_bar_node.value = current_value

func changeAction(new_value):
	action_bar_node.value = new_value
