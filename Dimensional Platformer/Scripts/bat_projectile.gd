extends CharacterBody2D

const SPEED = 200

enum State{FLYING, EXPLODING}
var curstate = State.FLYING
var dir = 1
@export
var parent:Node2D

var light_player:Node2D
var dark_player:Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	light_player = get_node("../../../LightPlayer") # get the player in each dimension
	dark_player = get_node("../../../DarkPlayer")

func set_vars(dir_, parent_):
	dir = dir_
	if dir < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	parent = parent_

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	if curstate == State.FLYING:
		velocity.x = SPEED * dir
	
	move_and_slide()
		
func switch_to(new_state):
	curstate = new_state
	if new_state == State.FLYING:
		$AnimatedSprite2D.play("main")
	elif new_state == State.EXPLODING:
		$AnimatedSprite2D.play("destroy")

func _on_body_entered(body):
	if body == light_player or body == dark_player:
		body.hit()
	if body != parent and body != self: # not colliding with self or parent
		print("gone " + body.name)
		switch_to(State.EXPLODING)
	
func _anim_finished():
	if curstate == State.FLYING:
		switch_to(State.FLYING)
	elif curstate == State.EXPLODING:
		self.queue_free()
