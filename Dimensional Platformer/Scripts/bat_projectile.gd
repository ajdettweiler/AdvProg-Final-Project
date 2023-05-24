extends CharacterBody2D

const SPEED = 200

enum State{FLYING, EXPLODING}
var curstate = State.FLYING
var dir = 1
@export
var parent:Node2D

var player:Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../../Player") # get the player in the same dimension
	if get_node("../..").name == "Light Dimension": # set collision layers and masks
		self.set_collision_layer_value(1, true)
		self.set_collision_mask_value(1, true)
		self.set_collision_layer_value(2, false)
		self.set_collision_mask_value(2, false)
	elif get_node("../..").name == "Dark Dimension":
		self.set_collision_layer_value(1, false)
		self.set_collision_mask_value(1, false)
		self.set_collision_layer_value(2, true)
		self.set_collision_mask_value(2, true)

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
	if body == player:
		player.hit()
	if body != parent and body != self: # not colliding with self or parent
		print("gone " + body.name)
		switch_to(State.EXPLODING)
	
func _anim_finished():
	if curstate == State.FLYING:
		switch_to(State.FLYING)
	elif curstate == State.EXPLODING:
		self.queue_free()
