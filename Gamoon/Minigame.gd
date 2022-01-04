extends Node2D

onready var player = get_node("PlayerHelper/Player")
var step_size = 5
var score = 0

var pressing_up = false
var pressing_down = false
var pressing_left = false
var pressing_right = false
var run = true

export (PackedScene) var Enemy

func update_score():
	if run:
		$ScoreLabel.text = "Score: " + str(score)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$PlayerHelper.position = get_viewport_rect().size / 2
	$Buttons.position.y = get_viewport_rect().size.y - 330
	$Buttons.position.x = get_viewport_rect().size.x / 2 - 105
	pass # Replace with function body.

func player_movement():
	if run:
		if Input.is_action_pressed("ui_up") or pressing_up:
			player.position.y -= step_size
		if Input.is_action_pressed("ui_down") or pressing_down:
			player.position.y += step_size
		if Input.is_action_pressed("ui_left") or pressing_left:
			player.position.x -= step_size
		if Input.is_action_pressed("ui_right") or pressing_right:
			player.position.x += step_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_movement()
	update_score()

func _on_ScoreTimer_timeout():
	if run:
		score += 1

func rand_bool():
	var r = randi()
	if r % 2:
		return true
	return false

func spawn_enemy():
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	
	var x = rand_range(0, width)
	var y = rand_range(0, height)
	var x_or_y = rand_range(0, 1)
	
	var xpos = 0
	var ypos = 0
	
	var enemy = Enemy.instance()
	add_child(enemy)
	
	if rand_bool():
		xpos = x
	else:
		ypos = y
		
	enemy.position.x = xpos
	enemy.position.y = ypos

func _on_SpawnTimer_timeout():
	if run:
		spawn_enemy()


func _on_Player_area_entered(area):
	$ScoreLabel.text = "You died. Score: " + str(score)
	run = false
	
	var file = File.new()
	file.open("score.json", File.WRITE)
	file.store_var(var2str(score), true)
	file.close()
	
	$GameOverTimer.start()
	pass # Replace with function body.


func _on_ButtonUp_button_up():
	pressing_up = false
	pass # Replace with function body.


func _on_ButtonUp_button_down():
	pressing_up = true
	pass # Replace with function body.


func _on_ButtonDown_button_up():
	pressing_down = false
	pass # Replace with function body.


func _on_ButtonDown_button_down():
	pressing_down = true


func _on_ButtonRight_button_down():
	pressing_right = true
	pass # Replace with function body.


func _on_ButtonRight_button_up():
	pressing_right = false
	pass # Replace with function body.


func _on_ButtonLeft_button_down():
	pressing_left = true
	pass # Replace with function body.


func _on_ButtonLeft_button_up():
	pressing_left = false
	pass # Replace with function body.


func _on_GameOverTimer_timeout():
	get_tree().change_scene("res://PetCare.tscn")
	pass # Replace with function body.
