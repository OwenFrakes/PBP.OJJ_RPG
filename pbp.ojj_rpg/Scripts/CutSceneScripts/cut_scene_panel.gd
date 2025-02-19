class_name CutScenePanel
extends Panel

@export var fade : bool = false
@export var fade_delay : float = 0
@export var fade_time : float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	if fade:
		pass

func activate():
	var panel_color = modulate
	if fade:
		while(modulate.a8 > 0):
			#Remove some small amount of alpha.
			panel_color.a8 -= 1
			
			#Update the panel.
			modulate = panel_color
			
			#Wait. 
			#Where the amount of wait time per change, is how long fade_time should last.
			await get_tree().create_timer(fade_time/255).timeout
	mouse_filter = MOUSE_FILTER_PASS
