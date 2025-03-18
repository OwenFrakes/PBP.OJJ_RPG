class_name TutorialButton
extends "res://Scripts/Interactables/interactable.gd"

@onready var particles : CPUParticles2D = $CPUParticles2D
@onready var animation : AnimatedSprite2D = $Animation 
@onready var lore = $"../Player/PlayerCamera/Control/LorePannel"

func interact():
	if lore.visible:
		lore.hide()
	else:
		lore.show()

	if particles.emitting:
		pass
	else:
		animation.play("default")
		await animation.animation_finished
		particles.emitting = true
