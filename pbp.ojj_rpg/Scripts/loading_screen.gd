extends Node2D

@onready var progress_bar = $Control/LoadingBar
@onready var background = $Control/SplashArt
@onready var continue_label = $Control/LoadingBar/ContinueLabel
var scene_to_be_loaded = "res://Scenes/world.tscn"
var splash_art = "res://Resources/Gubbins/TitleImage.png"
var loaded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	background.texture = load(splash_art)
	continue_label.hide()
	
	#This has to be last. Just to be safe.
	ResourceLoader.load_threaded_request(scene_to_be_loaded)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var progress = []
	var progress_enum = ResourceLoader.load_threaded_get_status(scene_to_be_loaded, progress)
	
	if progress_enum == ResourceLoader.THREAD_LOAD_LOADED && !loaded:
		loaded = true
		progress_bar.value = progress_bar.max_value
		continue_label.show()
	
	elif progress_enum == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		progress_bar.value = progress[0]
	

func _input(_event):
	if(Input.is_action_just_pressed("SpaceBar") && loaded):
		get_tree().paused = false
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene_to_be_loaded))
		free()
