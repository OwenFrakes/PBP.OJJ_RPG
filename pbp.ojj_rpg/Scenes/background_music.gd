extends AudioStreamPlayer

var music = [load("res://Resources/Music/Overworld.mp3"), load("res://Resources/Music/Battle.mp3")]
@onready var player_reference = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = music[0]
	play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(player_reference.inFight && stream != music[1]):
		stream = music[1]
		play()
	elif(!player_reference.inFight && stream != music[0]):
		stream = music[0]
		play()
	
