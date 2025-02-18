extends Label

## Intended Use ##
#place the label in the world with text you want it to show. 
#Then when the label is loaded, the script will place the text.

var default_text
var text_array = []

func _ready() -> void:
	default_text = text
	
	var last_new_line = 0
	while(default_text.find("\n", last_new_line + 2) > -1):
		#Get where the next line is.
		var next_new_line = default_text.find("\n", last_new_line + 2)
		
		if next_new_line == -1:
			#Get the rest of the text.
			text_array.append(default_text.substr(last_new_line))
		
		else:
			if(last_new_line == 0):
				text_array.append(default_text.substr(last_new_line, next_new_line - last_new_line))
			else:
				#Get the text between the two points and add it to the array.
				text_array.append(default_text.substr(last_new_line+2, next_new_line - last_new_line))
		
		#Set last_new_line to the next 
		last_new_line = next_new_line
	
	for text_thing in text_array:
		print(text_thing)
	
	#Clear the label.
	text = ""
	
	#Mysterious Wait, for effect.
	await get_tree().create_timer(1).timeout
	
	#Start to print the text from left to right, code / console style.
	for text_string in text_array:
		await writeText(text_string)
		await get_tree().create_timer(0.5).timeout
		
		#New line for next text.
		text += "\n"

func writeText(new_text):
	#Place letters left to right with this speed.
	for i in len(new_text):
		text += new_text.substr(i, 1)
		await get_tree().create_timer(0.05).timeout
