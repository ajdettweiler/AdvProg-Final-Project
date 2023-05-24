extends "res://Scripts/enemy.gd"


const SPEED = 100.0
const SIGHT_DIST = 200.0

var last_dir = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rng:RandomNumberGenerator

func _ready():
	super()
	rng = RandomNumberGenerator.new()
	if selfDim == "Light": # set collision layers and masks
		self.set_collision_layer_value(1, true)
		self.set_collision_mask_value(1, true)
		self.set_collision_layer_value(2, false)
		self.set_collision_mask_value(2, false)
	else:
		self.set_collision_layer_value(1, false)
		self.set_collision_mask_value(1, false)
		self.set_collision_layer_value(2, true)
		self.set_collision_mask_value(2, true)

func _physics_process(delta):
	state_timer += delta
	# handle sideways movement here
	var player_vec = player.position.x - self.position.x
	if abs(player_vec) <= SIGHT_DIST: # player is in sight distance
		if curstate == State.IDLE:
			switch_to(State.MOVING)
		velocity.x = -SPEED if player_vec < 0 else SPEED
	else: # player not in sight distanceq
		if curstate == State.IDLE and state_timer >= 2.0: # time to move for a bit
			velocity.x = SPEED if rng.randf() < 0.5 else -SPEED
			switch_to(State.MOVING)
		elif curstate == State.MOVING and state_timer >= 1.0:
			velocity.x = 0
			switch_to(State.IDLE)
		
		
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
	last_dir = velocity.x
	
func switch_to(new_state):
	super(new_state)
	# flip correctly
	if velocity.x:
		if velocity.x < 0: $AnimatedSprite2D.flip_h = true
		else: $AnimatedSprite2D.flip_h = false
	elif last_dir:
		if last_dir < 0: $AnimatedSprite2D.flip_h = true
		else: $AnimatedSprite2D.flip_h = false
		
	if new_state == State.IDLE:
		$AnimatedSprite2D.play("idle")
	if new_state == State.MOVING:
		$AnimatedSprite2D.play("walk")
	elif new_state == State.ATTACKING:
		$AnimatedSprite2D.play("attack")
	elif new_state == State.HIT:
		$AnimatedSprite2D.play("hit")
	elif new_state == State.DYING:
		$AnimatedSprite2D.play("death")
	elif new_state == State.DEAD:
		self.queue_free()
		
func hit():
	super()
	if health <= 0:
		switch_to(State.DYING)
	else:
		switch_to(State.HIT)



func _on_animated_sprite_2d_animation_finished():
	if curstate == State.DYING:
		switch_to(State.DEAD)
	elif curstate == State.ATTACKING or curstate == State.HIT:
		switch_to(State.IDLE)
	else:
		switch_to(curstate)
