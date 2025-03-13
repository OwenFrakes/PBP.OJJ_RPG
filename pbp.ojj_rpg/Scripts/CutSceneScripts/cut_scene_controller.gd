class_name CutSceneController
extends Control

@export var start_delay : float = 0
@export var children_time_gap : float = 0

func _ready():
	show()
	var children_effects = get_children()
	
	await get_tree().create_timer(start_delay).timeout
	
	for i in children_effects.size():
		#Children must have an activate method to work.
		if (children_effects[i].has_method("activate")):
			#Activate the children.
			await children_effects[i].activate()
			
			if(i != children_effects.size() - 1):
				await get_tree().create_timer(children_time_gap).timeout
	print("For loop over.")
	hide()
	mouse_filter = MOUSE_FILTER_PASS
	

func _input(event):
	if event.is_action("SpaceBar"):
		hide()
		mouse_filter = MOUSE_FILTER_PASS
