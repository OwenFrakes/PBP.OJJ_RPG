class_name TutorialButton
extends "res://Scripts/Interactables/interactable.gd"

@onready var particles : CPUParticles2D = $CPUParticles2D
@onready var animation : AnimatedSprite2D = $Animation 
@onready var lorePan = $"../Player/PlayerCamera/Control/LorePannel"
@onready var pic = $"../Player/PlayerCamera/Control/LorePannel/ItemPic"
@onready var itemName = $"../Player/PlayerCamera/Control/LorePannel/ItemName"
@onready var itemInfo = $"../Player/PlayerCamera/Control/LorePannel/ItemInfo"

func interact():
	itemName.text = "working"
	itemInfo.text = "nuh uh"
	pic.texture = load("res://Resources/Character/dante.png")
	if lorePan.visible:
		lorePan.hide()
	else:
		lorePan.show()

	if particles.emitting:
		pass
	else:
		animation.play("default")
		await animation.animation_finished
		particles.emitting = true
