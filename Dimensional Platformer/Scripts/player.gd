extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -800.0

enum State {JUMPING, IDLE, WALKING}
var curstate = State.IDLE
var state_timer = 0.0

var last_dir = 1
var direction = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	get_node("../Death Zone").connect("body_entered", _on_body_entered_death_zone)

func _physics_process(delta):	
	state_timer += delta
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		switch_to(State.JUMPING)
	if curstate == State.JUMPING and state_timer > 1.0:
		switch_to(State.IDLE)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if curstate != State.WALKING:
			switch_to(State.WALKING)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if last_dir and not direction and curstate != State.IDLE:
		switch_to(State.IDLE)
	
	last_dir = direction

	move_and_slide()
	
func switch_to(state):
	curstate = state
	state_timer = 0.0
	
	if state == State.IDLE:
		$AnimatedSprite2D.play("idle")
		if last_dir > 0:
			$AnimatedSprite2D.flip_h = false
		elif last_dir < 0:
			$AnimatedSprite2D.flip_h = true
	elif state == State.JUMPING:
		$AnimatedSprite2D.play("jump")
	elif state == State.WALKING:
		$AnimatedSprite2D.play("walking")
		if direction < 0:
			$AnimatedSprite2D.flip_h = true
		elif direction > 0:
			$AnimatedSprite2D.flip_h = false

func _on_animated_sprite_2d_animation_finished():
	if curstate == State.JUMPING:
		switch_to(State.IDLE)
		
func _on_body_entered_death_zone(body):
	if body == self:
		get_tree().change_scene_to_file('res://Scenes/test_scene.tscn')
		print("ouchie")
