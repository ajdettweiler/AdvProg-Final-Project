extends "res://Scripts/enemy.gd"

const SPEED = 5

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = self.player.position.x - self.position.x
	
	$AnimatedSprite2D.play("fly_right")
	
	move_and_collide(Vector2(direction, 0).normalized() * SPEED)

func switch_to(new_state):
	super.switch_to(new_state) # switch states

func hit():
	super.hit()
	switch_to(State.HIT)
