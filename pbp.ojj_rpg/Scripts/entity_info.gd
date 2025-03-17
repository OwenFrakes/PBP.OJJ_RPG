class_name EntityInfo
extends Control

####Top to bottom, what's shown.####

#Image First
var image_node = AnimatedSprite2D.new()

##Start Vertical Box##
var vertical_container = VBoxContainer.new()

##Grid Container for Conditions##
var condition_container = GridContainer.new()
var condition_dictionary = Dictionary()

#Entity Name
var name_label_node = Label.new()

#Health
var health_center_container = CenterContainer.new()
var health_bar_node = ProgressBar.new()
var health_label_node = Label.new()

#Mana
var mana_center_container = CenterContainer.new()
var mana_bar_node = ProgressBar.new()
var mana_label_node = Label.new()

#Action Bar Stuff
var action_bar_node = ProgressBar.new()

##End Vertical Box##

##Other Variables##
const greyout_color = Color(0.8, 0.8, 0.8)
var is_greyed_out = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	texture_filter = TEXTURE_FILTER_NEAREST
	
	#Add Sprite First
	add_child(image_node)
	image_node.scale = Vector2(2,2)
	
	var sprite_x_size = image_node.sprite_frames.get_frame_texture("idle", 0).get_size().x
	
	#Grid Container
	condition_container.columns=4
	condition_container.theme = load("res://Resources/Themes/GridTheme.tres")
	
	#VBoxContainer
	vertical_container.size = Vector2(image_node.sprite_frames.get_frame_texture("idle", 0).get_size().x * 2, 10)
	vertical_container.position = Vector2(-image_node.sprite_frames.get_frame_texture("idle", 0).get_size().x, \
										   image_node.sprite_frames.get_frame_texture("idle", 0).get_size().y)
	add_child(vertical_container)
	
	#Other Node edits.
	name_label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	health_label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mana_label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	#Health
	health_bar_node.self_modulate = Color(1,0,0)
	health_bar_node.show_percentage = false
	health_bar_node.custom_minimum_size = Vector2(sprite_x_size * 2,20)
	health_label_node.self_modulate = Color(1,1,1)
	health_label_node.position = Vector2(health_bar_node.size.x/2, health_bar_node.size.y/2)
	#health_label_node.set_anchor()
	
	#Mana
	mana_bar_node.self_modulate = Color(0,0,1)
	mana_bar_node.show_percentage = false
	mana_bar_node.custom_minimum_size = Vector2(sprite_x_size * 2,20)
	mana_label_node.self_modulate = Color(1,1,1)
	
	#Action
	action_bar_node.self_modulate = Color(0,1,0)
	
	###Add the bars to the container###
	vertical_container.add_child(condition_container)
	#Name
	vertical_container.add_child(name_label_node)
	#Health
	vertical_container.add_child(health_center_container)
	health_center_container.add_child(health_bar_node)
	health_center_container.add_child(health_label_node)
	#Mana
	vertical_container.add_child(mana_center_container)
	mana_center_container.add_child(mana_bar_node)
	mana_center_container.add_child(mana_label_node)
	#Action
	vertical_container.add_child(action_bar_node)
	

func _init(new_label : String, new_texture : SpriteFrames = load("res://Resources/Character/SpriteSets/blue_robot_set.tres")) -> void:
	image_node.sprite_frames = new_texture
	image_node.play("idle")
	image_node.stop()
	image_node.frame = 0
	name_label_node.text = new_label

func isEnemy():
	mana_bar_node.hide()
	mana_label_node.hide()

##Image Functions#########################################
func greyout(boolean : bool) -> void:
	if boolean:
		image_node.self_modulate = greyout_color
	else:
		image_node.self_modulate = Color(1,1,1)

func getGreyedOut() -> bool:
	return is_greyed_out

func addCondition(condition_name : String):
	if condition_dictionary.get(condition_name) == null:
		var condition_sprite = TextureRect.new()
		condition_sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		condition_sprite.texture = load("res://Resources/Conditions/IceCondition.png")
		condition_sprite.custom_minimum_size = Vector2(32,32)
		condition_dictionary.get_or_add(condition_name, condition_sprite)
		condition_container.add_child(condition_sprite)

##Health###################################################
func setHealthBar(new_max, current_value = new_max):
	health_bar_node.max_value = new_max
	health_bar_node.value = current_value
	
	health_label_node.text = "Health: " + str(int(current_value)) + "/" + str(int(new_max))

func changeHealth(new_value):
	health_bar_node.value = new_value
	health_label_node.text = "Health: " + str(int(new_value)) + "/" + str(int(health_bar_node.max_value))

##Mana###################################################
func setManaBar(new_max, current_value = new_max):
	mana_bar_node.max_value = new_max
	mana_bar_node.value = current_value
	
	mana_label_node.text = "Mana: " + str(int(current_value)) + "/" + str(int(new_max))

func changeMana(new_value):
	mana_bar_node.value = new_value
	mana_label_node.text = "Mana: " + str(int(new_value)) + "/" + str(int(mana_bar_node.max_value))

##Action###################################################
func setActionBar(new_max, current_value = 0):
	action_bar_node.max_value = new_max
	action_bar_node.value = current_value

func changeAction(new_value):
	action_bar_node.value = new_value
