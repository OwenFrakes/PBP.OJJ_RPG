class_name CutSceneLabel
extends Label

## Intended Use ##
#place the label in the world with text you want it to show. 
#Then when the label is loaded, the script will place the text.

## Variables ##
var default_text : String
var text_array = []

## Exports for Inspector ##
@export var line_delay : float = 0
@export var text_delay : float = 0
@export var kill_text_after : bool = false
@export var kill_delay : float = 0

func _ready():
	#Get the text, for safety reasons.
	default_text = text
	
	#This split method is perfect. No whiles, no nothing.
	text_array = default_text.split("\n")
	
	#Clear the label.
	text = ""

#This method name is crucial for the CutSceneController to work.
func activate():
	
	#Start to print the text from left to right, code / console style.
	for i in text_array.size():
		await writeText(text_array[i])
		#New line for next text.
		text += "\n"
		
		if i != text_array.size()-1:
			await get_tree().create_timer(line_delay).timeout
	
	if kill_text_after:
		await get_tree().create_timer(kill_delay).timeout
		hide()
	

func writeText(new_text):
	#Place letters left to right with this speed.
	for i in len(new_text):
		text += new_text.substr(i, 1)
		await get_tree().create_timer(text_delay).timeout
