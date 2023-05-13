extends "res://Scripts/enemy.gd"

const SPEED = 100
const FALL_SPEED = 200
const sight_dist = 500

var proj = preload("res://Scenes/bat_projectile.tscn")
var direction = 1

const DEATH_STATES = [State.DYING, State.DEAD, State.FALLING]

var mouse_over = false

func _physics_process(delta):
	state_timer += delta
	if state_timer > 3.0 and curstate == State.DEAD: # if time has passed and the bat is dead
		self.queue_free() # destroy node
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = self.player.position.x - self.position.x
	velocity = Vector2.ZERO
	
	if curstate == State.FALLING:
		if is_on_floor():
			switch_to(State.DEAD)
		else: 
			velocity.y = FALL_SPEED # fall
		
	if Input.is_action_just_pressed("click") and mouse_over: # if player clicks and the bat is being clicked
		hit() # take damage
	if Input.is_action_just_pressed("interact"):
		shoot_projectile()
	
	if abs(direction) < sight_dist and curstate not in DEATH_STATES: # the bat can see the player
		if curstate == State.IDLE:
			switch_to(State.MOVING) # start to move
		if abs(direction) > 100: # prevent jittery movement
			velocity.x = Vector2(direction, 0).normalized().x * SPEED
		if direction < 0: # flip if necessary
			$AnimatedSprite2D.flip_h = true
		elif direction > 0:
			$AnimatedSprite2D.flip_h = false
	elif curstate == State.MOVING: # stop moving
		switch_to(State.IDLE) # go to idle
		
	move_and_slide()

func switch_to(new_state):
	super.switch_to(new_state) # switch states
	if new_state == State.IDLE:
		$AnimatedSprite2D.play("fly_right")
	elif new_state == State.MOVING:
		$AnimatedSprite2D.play("fly_right")
	elif new_state == State.HIT:
		$AnimatedSprite2D.play("hit")
	elif new_state == State.ATTACKING:
		$AnimatedSprite2D.play("attack")
	elif new_state == State.DYING:
		$AnimatedSprite2D.play("death1")
	elif new_state == State.FALLING:
		$AnimatedSprite2D.play("falling")
	elif new_state == State.DEAD:
		$AnimatedSprite2D.play("death2")
		
func hit():
	if curstate not in DEATH_STATES:
		super.hit()
		if health <= 0:
			switch_to(State.DYING)
		else:
			switch_to(State.HIT)

func shoot_projectile():
	var instance = proj.instantiate()
	instance.set_dir(-1 if direction < 0 else 1)
	self.get_parent().add_child(instance)

func _on_animated_sprite_2d_animation_finished():
	if curstate == State.HIT:
		switch_to(State.IDLE)
	elif curstate == State.ATTACKING:
		switch_to(State.IDLE)
	elif curstate == State.DYING:
		switch_to(State.FALLING)
	elif curstate == State.DEAD:
		$AnimatedSprite2D.pause()
		
	else:
		switch_to(curstate)



func _on_mouse_entered():
	mouse_over = true

func _on_area_2d_mouse_exited():
	mouse_over = false
