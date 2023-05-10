extends "res://Scripts/enemy.gd"

const SPEED = 3
const sight_dist = 500

var mouse_over = false

func _physics_process(delta):
	state_timer += delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = self.player.position.x - self.position.x
	var move_dir = Vector2.ZERO
	
	if curstate == State.FALLING:
		if is_on_floor():
			switch_to(State.DEAD)
		move_dir.y = -1
		
	if Input.is_action_just_pressed("click") and mouse_over:
		hit()
	
	if abs(direction) < sight_dist: # the bat can see the player
		if curstate == State.IDLE:
			switch_to(State.MOVING) # start to move
		if abs(direction) > 50: # prevent jittery movement
			move_dir.x = direction
		if direction < 0: # flip if necessary
			$AnimatedSprite2D.flip_h = true
		elif direction > 0:
			$AnimatedSprite2D.flip_h = false
	elif curstate == State.MOVING: # stop moving
		switch_to(State.IDLE) # go to idle
	
	move_and_collide(move_dir.normalized() * SPEED)

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
	super.hit()
	if health <= 0:
		switch_to(State.DYING)
	else:
		switch_to(State.HIT)


func _on_animated_sprite_2d_animation_finished():
	if curstate == State.HIT:
		switch_to(State.IDLE)
	elif curstate == State.ATTACKING:
		switch_to(State.IDLE)
	elif curstate == State.DYING:
		switch_to(State.FALLING)
	elif curstate == State.DEAD:
		if state_timer > 1.0:
			self.queue_free()
		$AnimatedSprite2D.pause()



func _on_mouse_entered():
	mouse_over = true

func _on_area_2d_mouse_exited():
	mouse_over = false
