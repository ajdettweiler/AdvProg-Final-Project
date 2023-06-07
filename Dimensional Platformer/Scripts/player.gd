extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -800.0

enum State {JUMPING, IDLE, WALKING, HIT, DEAD}
var curstate = State.IDLE
var state_timer = 0.0

var last_dir = 1
var direction = 0

var anim = null

var health = 2

var is_current_player = false
var is_light_player = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if self.name == "LightPlayer":
		get_node("../Light Dimension/Death Zone").connect("body_entered", _on_body_entered_death_zone)
		get_node("../Light Dimension/Portal").connect("body_entered", _on_body_entered_portal)
	if self.name == "DarkPlayer":
		get_node("../Dark Dimension/Death Zone").connect("body_entered", _on_body_entered_death_zone)
		get_node("../Dark Dimension/Portal").connect("body_entered", _on_body_entered_portal)
		
	anim = $AnimatedSprite2D
	
	is_current_player = (Globals.is_light_dimension and self.name =="LightPlayer") or (not Globals.is_light_dimension and self.name == "DarkPlayer")

func _physics_process(delta):
	state_timer += delta
	
	is_current_player = (Globals.is_light_dimension and self.name =="LightPlayer") or (not Globals.is_light_dimension and self.name == "DarkPlayer")
	
	if state_timer > 3.0 and curstate == State.DEAD:
		reset_scene()
	if Input.is_action_just_pressed("reset"):
		reset_scene()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if curstate != State.DEAD:
		if Input.is_action_just_pressed("jump") and is_on_floor() and is_current_player:
			velocity.y = JUMP_VELOCITY
			switch_to(State.JUMPING)
		if curstate == State.JUMPING and state_timer > 1.0:
			switch_to(State.IDLE)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if is_current_player and curstate != State.DEAD:
		direction = Input.get_axis("move_left", "move_right")
	else:
		direction = 0
		
	velocity.x = direction * SPEED
	if direction != 0:
		if curstate != State.WALKING:
			switch_to(State.WALKING)
		move_toward(direction, 0, delta)
	if last_dir and not direction and curstate != State.IDLE:
		switch_to(State.IDLE)
	
	last_dir = direction
	move_and_slide()

func switch_to(state):
	curstate = state
	state_timer = 0.0
	
	if state == State.IDLE:
		anim.play("idle")
		if last_dir > 0:
			anim.flip_h = false
		elif last_dir < 0:
			anim.flip_h = true
	elif state == State.JUMPING:
		anim.play("jump")
	elif state == State.WALKING:
		anim.play("walking")
		if direction < 0:
			anim.flip_h = true
		elif direction > 0:
			anim.flip_h = false
	elif state == State.HIT:
		anim.play("hit")
		if direction:
			if direction < 0:
				anim.flip_h = true
			elif direction > 0:
				anim.flip_h = false
		else:
			if last_dir < 0:
				anim.flip_h = true
			elif last_dir > 0:
				anim.flip_h = false
	elif state ==State.DEAD:
		anim.play("death")
		if direction:
			if direction < 0:
				anim.flip_h = true
			elif direction > 0:
				anim.flip_h = false
		else:
			if last_dir < 0:
				anim.flip_h = true
			elif last_dir > 0:
				anim.flip_h = false
			
func hit():
	reset_scene()
#	health -= 1
#	print(health)
#	if health <= 0:
#		switch_to(State.DEAD)
#	else:
#		switch_to(State.HIT)

func _on_animated_sprite_2d_animation_finished():
	if curstate == State.JUMPING:
		switch_to(State.IDLE)
	elif curstate == State.HIT:
		switch_to(State.IDLE)
	elif curstate == State.DEAD:
		anim.pause()
		
			
func _on_body_entered_death_zone(body):
	if body == self:
		reset_scene()

func _on_body_entered_portal(body):
	if body == self:
		if self.name == "LightPlayer":
			if not get_parent().dark_player_through:
				get_parent().switch_dim()
			get_parent().light_player_through = true
		if self.name == "DarkPlayer":
			if not get_parent().light_player_through:
				get_parent().switch_dim()
			get_parent().dark_player_through = true
		
func reset_scene():
	get_tree().change_scene_to_file(get_node("..").cur_scene_path)
	Globals.is_light_dimension = get_node("..").start_light_dim
	print("ouchie")
	
		
		
