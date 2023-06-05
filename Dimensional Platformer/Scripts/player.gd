extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -800.0

enum State {JUMPING, IDLE, WALKING}
var curstate = State.IDLE
var state_timer = 0.0

var last_dir = 1
var direction = 0

var anim = null

var health = 10
var is_current_player = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	get_node("../Death Zone").connect("body_entered", _on_body_entered_death_zone)
	anim = $AnimatedSprite2D
	
	is_current_player = (Globals.is_light_dimension and get_node("..").name == "Light Dimension") or ((not Globals.is_light_dimension) and get_node("..").name == "Dark Dimension")
	
	
	if get_node("..").name == "Light Dimension": # set collision layers and masks
		self.set_collision_layer_value(1, true)
		self.set_collision_mask_value(1, true)
		self.set_collision_layer_value(2, false)
		self.set_collision_mask_value(2, false)
	elif get_node("..").name == "Dark Dimension":
		self.set_collision_layer_value(1, false)
		self.set_collision_mask_value(1, false)
		self.set_collision_layer_value(2, true)
		self.set_collision_mask_value(2, true)

func _physics_process(delta):
	state_timer += delta
	
	is_current_player = (Globals.is_light_dimension and get_node("..").name == "Light Dimension") or (!Globals.is_light_dimension and get_node("..").name == "Dark Dimension")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and is_current_player:
		velocity.y = JUMP_VELOCITY
		switch_to(State.JUMPING)
	if curstate == State.JUMPING and state_timer > 1.0:
		switch_to(State.IDLE)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if is_current_player:
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
			
func hit():
	health -= 1
	print(health)
	if health <= 0:
		print("ouchie")
		get_tree().change_scene_to_file(get_node("../..").cur_scene_path)
		Globals.is_light_dimension = false

func _on_animated_sprite_2d_animation_finished():
	if curstate == State.JUMPING:
		switch_to(State.IDLE)
		
func _on_collision(body):
	print(body.name)
		
			
func _on_body_entered_death_zone(body):
	if body == self:
		get_tree().change_scene_to_file(get_node("../..").cur_scene_path)
		Globals.is_light_dimension = false
		print("ouchie")
		
		
