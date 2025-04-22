class_name ConditionSprite
extends TextureRect

var image : String
var duration : int
var label : Label

func _init(new_image, new_duration) -> void:
	image = new_image
	duration = new_duration
	
	# Condition Sprite Settings
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture = load(image)
	custom_minimum_size = Vector2(32,32)
	
	# Label for Conditions
	label = Label.new()
	label.theme = load("res://Resources/Themes/ConditionTheme.tres")
	label.text = str(duration)
	label.custom_minimum_size = Vector2(32,32)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.hide()
	
	# Using signals, the number appears and disappears when the mouse hovers.
	mouse_entered.connect(label.show)
	mouse_exited.connect(label.hide)
	add_child(label)

func updateLabel(new_duration):
	label.text = str(new_duration)
