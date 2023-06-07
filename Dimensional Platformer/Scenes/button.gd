extends Area2D

@export
var toggle_layer = 1
@export
var one_time = true
@export
var dest_dim = 'Light'

var pressed = false

var light_player:Node2D
var dark_player:Node2D
var selfDim = 'Dark'

# Called when the node enters the scene tree for the first time.
func _ready():
	light_player = get_node("../../LightPlayer")
	dark_player = get_node("../../DarkPlayer")
	if self.get_parent().get_parent().name == "Light Dimension":
		selfDim = 'Light'

func _on_body_entered(body):
	if not pressed:
		if body == light_player or body == dark_player:
			self.pressed = true
			$ButtonOnFX.play()
			self.position.y += 10
			var tm:TileMap = get_node("../../"+dest_dim+" Dimension/TileMap")
			tm.set_layer_enabled(toggle_layer, not tm.is_layer_enabled(toggle_layer))


func _on_body_exited(body):
	if pressed and not one_time:
		if body == light_player or body == dark_player:
			self.pressed = false
			$ButtonOffFX.play()
			self.position.y -= 10 # move back up
			var tm:TileMap = get_node("../../"+dest_dim+" Dimension/TileMap")
			tm.set_layer_enabled(toggle_layer, not tm.is_layer_enabled(toggle_layer))
