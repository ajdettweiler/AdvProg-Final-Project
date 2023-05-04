class_name Enemy extends CharacterBody2D

var player:Node2D
var health = 5

enum State {MOVING, IDLE, ATTACKING, HIT, DYING, DEAD}
var curstate = State.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	self.player = get_tree().get_root().find_child("Player", true, false)

func switch_to(new_state):
	curstate = new_state

func hit():
	health -= 1
