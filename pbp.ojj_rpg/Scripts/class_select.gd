extends Node
var pClass : PlayerClass
var classes : Array
var selected_class: int

signal selected_class_changed()

@onready var character_title: Label = $CharacterSelect/CharacterTitle
@onready var character_description: RichTextLabel = $CharacterSelect/CharacterDescription
@onready var attack_description: RichTextLabel = $CharacterSelect/AttackDescription
@onready var character_sprite: AnimatedSprite2D = $CharacterSelect/CryoPod/CharacterSprite

## Sprite Sets ##
var brawler_sprite_set = load("res://Resources/Character/SpriteSets/brawler_set.tres")
var swordsman_sprite_set = load("res://Resources/Character/SpriteSets/swordsman_set.tres")
var gunslinger_sprite_set = load("res://Resources/Character/SpriteSets/gunslinger_set.tres")
var engineer_sprite_set = load("res://Resources/Character/SpriteSets/engineer_set.tres")
var marksman_sprite_set = load("res://Resources/Character/SpriteSets/marksman_set.tres")

func _ready() -> void:
	pClass = PlayerClass.new()
	classes = []
	classes.resize(5)
	
	## 3 Main Aspects, Damage, Health, and Speed.
	# Best to Worst
	# Great, Good, Okay, Average, Bad, Terrible, Worst.
	
	# Okay damage, good health, speed is bad. Brusier.
	#Brawler
	classes[0] = PlayerClass.new()
	classes[0].setClass("Brawler", 200, 20, 20, "Fists", 40, 0.75, "bash", ["electric", "ice"], brawler_sprite_set)
	
	# Good slash damage, okay health, is average speed.
	#Swordsman
	classes[1] = PlayerClass.new()
	classes[1].setClass("Swordsman", 150, 10, 6, "Sword", 60, 1, "slash", ["dark", "fire"], swordsman_sprite_set)
	
	# Good pierce damage, bad health, is pretty fast.
	#Gun Slinger
	classes[2] = PlayerClass.new()
	classes[2].setClass("Gun Slinger", 100, 20, 8, "Revolver", 60, 1.5, "pierce", ["pierce", "light"], gunslinger_sprite_set)
	
	# Okay damage, decent health, average speed.
	#Should have more utility based options.
	#Engineer
	classes[3] = PlayerClass.new()
	classes[3].setClass("Engineer", 150, 20, 20, "Wrench", 40, 1, "bash", ["slash", "dark"], engineer_sprite_set)
	
	# Great Pierce Damage, Terrible Health, Bad speed.
	#Marksman
	classes[4] = PlayerClass.new()
	classes[4].setClass("Marksman", 75, 20, 20, "Sniper", 80, 0.5, "pierce", ["light, fire"], marksman_sprite_set)
	
	#Change text to tell player what they have selected.
	pClass = classes[0]
	character_description.text = "Name: " + pClass.getName() + \
	"\nWeapon: " + pClass.getWeaponName() + \
	"\nHealth: " + str(pClass.getHealth()) + \
	"\nStamina:" + str(pClass.getStamina()) + \
	"\nMana:" + str(pClass.getMana()) 
	
	selected_class_changed.connect(updateClassDescriptions)

func updateClassDescriptions() -> void:
	character_title.text = pClass.cName

func _on_select_button_pressed() -> void:
	#Make the global singleton have these stats.
	PlayerStats.selected_player_class = classes[selected_class]
	PlayerStats.selected_player_weapon = classes[selected_class].pWeapon
	#Go to next scene.
	var loading_screen = preload("res://Scenes/loadingScreen.tscn").instantiate()
	loading_screen.scene_to_be_loaded = "res://Scenes/world.tscn"
	get_tree().root.add_child(loading_screen)

## Class Switch Methods ##

func setSelectedClass(class_num : int) -> void:
	selected_class = class_num
	pClass = classes[selected_class]
	selected_class_changed.emit()

func setToBrawler() -> void:
	setSelectedClass(0)

func setToSwordsman() -> void:
	setSelectedClass(1)

func setToGunslinger() -> void:
	setSelectedClass(2)

func setToEngineer() -> void:
	setSelectedClass(3)

func setToSniper() -> void:
	setSelectedClass(4)
