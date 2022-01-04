extends Node2D

onready var enemy = get_node("Area2D")
var step_size = rand_range(100, 500)

var go_up = rand_bool()
var go_down = rand_bool()
var go_left = rand_bool()
var go_right = rand_bool()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func change_behavior():
	go_up = rand_bool()
	go_down = rand_bool()
	go_left = rand_bool()
	go_right = rand_bool()

func rand_bool():
	var r = randi()
	if r % 2:
		return true
	return false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var real_step_size = step_size * delta
	
	if go_up:
		enemy.position.y -= real_step_size
	if go_down:
		enemy.position.y += real_step_size
	if go_left:
		enemy.position.x -= real_step_size
	if go_right:
		enemy.position.x += real_step_size


func _on_Timer_timeout():
	change_behavior()
	pass # Replace with function body.
