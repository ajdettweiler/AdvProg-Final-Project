class_name Enemy extends CharacterBody2D

var player:Node2D
var health = 5
var selfDim = 'Dark'

enum State {MOVING, IDLE, ATTACKING, HIT, DYING, FALLING, DEAD}
var curstate = State.IDLE
var state_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if self.get_parent().get_parent().name == "Light Dimension":
		selfDim = 'Light'
		
	self.player = get_node("../../Player")

func switch_to(new_state):
	curstate = new_state
	state_timer = 0.0

func hit():
	health -= 1
