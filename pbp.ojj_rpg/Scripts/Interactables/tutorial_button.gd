class_name TutorialButton
extends "res://Scripts/Interactables/interactable.gd"

@onready var particles : CPUParticles2D = $CPUParticles2D
@onready var animation : AnimatedSprite2D = $Animation 
@onready var lorePan = $"../Player/PlayerCamera/Control/LorePannel"
@onready var pic = $"../Player/PlayerCamera/Control/LorePannel/ItemPic"
@onready var itemName = $"../Player/PlayerCamera/Control/LorePannel/ItemName"
@onready var itemInfo = $"../Player/PlayerCamera/Control/LorePannel/ItemInfo"
var count = 0
var disks: Array
var firstTime := true

func setDisks():
	disks.resize(10)
	print(disks.size())
	disks[0] = Disk.new()
	disks[0].setDisk("Disk 1", "res://Resources/Character/dante.png", "This is disk 1")
	disks[1] = Disk.new()
	disks[1].setDisk("Disk 2", "res://Resources/icon.svg", "This is disk 2")
	disks[2] = Disk.new()
	disks[2].setDisk("Disk 3", "res://Resources/Tree-2.png.png", "This is disk 3")
	disks[3] = Disk.new()
	disks[3].setDisk("Disk 4", "res://Resources/Grass1-3.png.png", "This is disk 4")
	disks[4] = Disk.new()
	disks[4].setDisk("Disk 5", "res://Resources/cryochamber-2.png.png", "This is disk 5")
	disks[5] = Disk.new()
	disks[5].setDisk("Disk 6", "res://Resources/Character/dante.png", "This is disk 6")
	disks[6] = Disk.new()
	disks[6].setDisk("Disk 7", "res://Resources/Character/dante.png", "This is disk 7")
	disks[7] = Disk.new()
	disks[7].setDisk("Disk 8", "res://Resources/Character/dante.png", "This is disk 8")
	disks[8] = Disk.new()
	disks[8].setDisk("Disk 9", "res://Resources/Character/dante.png", "This is disk 9")
	disks[9] = Disk.new()
	disks[9].setDisk("Disk 10", "res://Resources/Character/dante.png", "This is disk 10")

func interact():
	if firstTime:
		setDisks()
		firstTime = false
	
	
	if(count > 9):
		count = 0
		itemName.text = disks[count].dName
		itemInfo.text = disks[count].discript
		pic.texture = load(disks[count].pic)
		if lorePan.visible:
			lorePan.hide()
		else:
			lorePan.show()
		count += 1
	else:
		itemName.text = disks[count].dName
		itemInfo.text = disks[count].discript
		pic.texture = load(disks[count].pic)
		if lorePan.visible:
			lorePan.hide()
		else:
			lorePan.show()
		count += 1

	if particles.emitting:
		pass
	else:
		animation.play("default")
		await animation.animation_finished
		particles.emitting = true
	
