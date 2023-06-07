extends Node2D

@export
var cur_scene_path = "res://Scenes/__.tscn"
@export
var start_light_dim = false
@export
var next_scene_path = "res://Scenes/__.tscn"

@export
var light_player_through = false
@export
var dark_player_through = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		# toggle paused
		pass
		#self.paused = !self.paused
		
		#if self.paused: # here do pausing logic, if paused make menu visible, else make it invisible
		#	print("Paused!")
		#else:
		#	print("Unpaused!")
	
	if Input.is_action_just_pressed("quit"):
		# replace this with UI input?, quit the game
		get_tree().quit()
	
	if Input.is_action_just_pressed("toggle_dimension"):
		switch_dim()
		
		
	if light_player_through and dark_player_through:
		get_tree().change_scene_to_file(next_scene_path)
		Globals.is_light_dimension = start_light_dim
		print("ouchie")


func switch_dim():
	if not dark_player_through and not light_player_through:
		if Globals.is_light_dimension: # change to dark dimension
			get_node("Light Dimension").hide()
			get_node("LightPlayer").hide()
			get_node("LightParallax").hide()
			get_node("Dark Dimension").show()
			get_node("DarkPlayer").show()
			get_node("DarkParallax").show()
			find_child("Camera2D", true, false).insta_move(get_node("LightPlayer").position.x, get_node("LightPlayer").position.y)
		else: # change to light dimension
			get_node("Dark Dimension").hide()
			get_node("DarkPlayer").hide()
			get_node("DarkParallax").hide()
			get_node("Light Dimension").show()
			get_node("LightPlayer").show()
			get_node("LightParallax").show()
			find_child("Camera2D", true, false).insta_move(get_node("LightPlayer").position.x, get_node("LightPlayer").position.y)
		Globals.is_light_dimension = !Globals.is_light_dimension
