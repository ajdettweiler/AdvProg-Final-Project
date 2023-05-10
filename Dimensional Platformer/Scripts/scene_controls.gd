extends Node2D


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
		# replace this with UI input, quit the game
		get_tree().quit()
	
	if Input.is_action_just_pressed("toggle_dimension"):
		if Globals.is_light_dimension: # change to dark dimension
			get_node("Light Dimension").hide()
			get_node("Light Dimension/LightDimensionPlayer").hide()
			get_node("Dark Dimension").show()
			get_node("Dark Dimension/DarkDimensionPlayer").show()
		else: # change to light dimension
			get_node("Dark Dimension").hide()
			get_node("Dark Dimension/DarkDimensionPlayer").hide()
			get_node("Light Dimension").show()
			get_node("Light Dimension/LightDimensionPlayer").show()
		
		Globals.is_light_dimension = !Globals.is_light_dimension
