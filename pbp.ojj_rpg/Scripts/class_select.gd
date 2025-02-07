extends Node
var pClass : PlayerClass
var classes : Array
var place: int

@onready var character_text = $"../../../CharacterStats"
@onready var animated_sprite_node = $"../../../../../AnimatedSprite2D"
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
	
	#Brawler
	classes[0] = PlayerClass.new()
	classes[0].setClass("Brawler", 100, 20,20, "Fists", 40, 50, "bash", ["electric", "ice"], brawler_sprite_set)
	
	#Swordsman
	classes[1] = PlayerClass.new()
	classes[1].setClass("Swordsman", 50, 10,6, "Sword", 40, 50, "slash", ["dark", "fire"], swordsman_sprite_set)
	
	#Gun Slinger
	classes[2] = PlayerClass.new()
	classes[2].setClass("Gun Slinger", 100, 20,8, "Revolver", 40, 50, "pierce", ["pierce", "light"], gunslinger_sprite_set)
	
	#Engineer
	classes[3] = PlayerClass.new()
	classes[3].setClass("Engineer", 100, 20,20, "Wrench", 40, 50, "bash", ["slash", "dark"], engineer_sprite_set)
	
	#Marksman
	classes[4] = PlayerClass.new()
	classes[4].setClass("Marksman", 100, 20,20, "Sniper", 40, 50, "pierce", ["light, fire"], marksman_sprite_set)
	
	#Change text to tell player what they have selected.
	pClass = classes[0]
	character_text.text = "Name: " + pClass.getName() + \
	"\nWeapon: " + pClass.getWeaponName() + \
	"\nHealth: " + str(pClass.getHealth()) + \
	"\nStamina:" + str(pClass.getStamina()) + \
	"\nMana:" + str(pClass.getMana()) 

func _on_pressed() -> void:
	#Cycle if more than 4, otherwise go to next class.
	if place == 4:
		place = 0
	else:
		place += 1
	
	#Change text to tell player what they have selected.
	pClass = classes[place]
	character_text.text = "Name: " + pClass.getName() + \
	"\nWeapon: " + pClass.getWeaponName() + \
	"\nHealth: " + str(pClass.getHealth()) + \
	"\nStamina:" + str(pClass.getStamina()) + \
	"\nMana:" + str(pClass.getMana()) 
	animated_sprite_node.sprite_frames = pClass.getSpriteSet()
	

func _on_previous_button_pressed() -> void:
	#Cycle backwards to 4 if more than 0, otherwise go to previous class.
	if place == 0:
		place = 4
	else:
		place -= 1
	
	#Change text to tell player what they have selected.
	pClass = classes[place]
	character_text.text = "Name: " + pClass.getName() + \
	"\nWeapon: " + pClass.getWeaponName() + \
	"\nHealth: " + str(pClass.getHealth()) + \
	"\nStamina:" + str(pClass.getStamina()) + \
	"\nMana:" + str(pClass.getMana()) 
	animated_sprite_node.sprite_frames = pClass.getSpriteSet()

func _on_select_button_pressed() -> void:
	#Make the global singleton have these stats.
	PlayerStats.selected_player_class = classes[place]
	PlayerStats.selected_player_weapon = classes[place].pWeapon
	#Go to next scene.
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
