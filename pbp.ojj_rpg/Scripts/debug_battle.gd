extends Control

#Existing Nodes
@onready var attacks_container: VBoxContainer = $ScrollControl/ScrollContainer/AttacksContainer
@onready var label: Label = $Label


#Variables
var selected_attack : Attack

func _ready() -> void:
	var this_attack = Attack.new()
	this_attack.setAttack("Basic Attack", 10, 2, 0, "fire", 1)
	var new_attack_button = AttackButton.new(this_attack)
	attacks_container.add_child(new_attack_button)
	
	var thais_attack = Attack.new()
	thais_attack.setAttack("SUPER Attack", 10, 2, 0, "fire", 1)
	var ne_attack_button = AttackButton.new(thais_attack)
	attacks_container.add_child(ne_attack_button)
	
	new_attack_button.send_attack.connect(setSelectedAttack)
	ne_attack_button.send_attack.connect(setSelectedAttack)

func setSelectedAttack(new_attack : Attack) -> void:
	selected_attack = new_attack
	label.text = selected_attack.getName()
