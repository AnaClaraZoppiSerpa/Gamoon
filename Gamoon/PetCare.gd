extends Node2D

var noodles = 0
var hunger = 50.0
var max_hunger = 100
var total_status_time = 5 * 60 * 60
var noodle_picture = preload("res://pet-noodle.png")
var main_picture = preload("res://pet-main.png")

func update_noodles():
	$UI/NoodleLabel.text = "Noodles: " + str(int(noodles))

func update_hunger():
	$UI/HungerLabel.text = "Hunger: " + str(int(hunger)) + "/" + str(max_hunger)

func save_game():
	var data = {
		"noodles": noodles,
		"hunger": hunger,
		"time": OS.get_unix_time()
	}
	var file = File.new()
	file.open("data.json", File.WRITE)
	file.store_var(var2str(data), true)
	file.close()

func load_game():
	var file = File.new()
	var loaded_game = null
	
	if file.file_exists("data.json"):
		file.open("data.json", File.READ)
		
		var got_var = file.get_var(true)
		if got_var != null:
			loaded_game = str2var(got_var)
		file.close()
	
	return loaded_game

func load_and_reset_score():
	var file = File.new()
	var loaded_score = 0
	
	if file.file_exists("score.json"):
		file.open("score.json", File.READ)
		
		var got_var = file.get_var(true)
		if got_var != null:
			loaded_score = str2var(got_var)
		
		file.close()
	
	var zero = 0
	file.open("score.json", File.WRITE)
	file.store_var(var2str(zero), true)
	file.close()
	
	return loaded_score

func get_new_hunger(last_hunger, last_time):
	var time_diff = OS.get_unix_time() - last_time
	var change = time_diff/total_status_time
	
	if last_hunger + change > 100:
		return 100
	
	return last_hunger + change

func _process(delta):
	update_noodles()
	update_hunger()
	save_game()
	pass

func init_vars():
	var vars = load_game()
	var last_score = load_and_reset_score()
	
	noodles = 0
	
	if vars == null:
		noodles = 0
		hunger = 50
	else:
		noodles = vars["noodles"]
		var last_hunger = vars["hunger"]
		var last_time = vars["time"]
		hunger = get_new_hunger(last_hunger, last_time)
	
	if last_score > 0:
		noodles += int(last_score/10)

func _ready():
	init_vars()
	$UI.position.y -= (1280 - get_viewport_rect().size.y)

func _on_GetButton_pressed():
	get_tree().change_scene("res://Minigame.tscn")
	pass # Replace with function body.

func _on_FeedButton_pressed():
	if noodles > 0:
		$UI/Pet.set_texture(noodle_picture)
		$NoodleTimer.start()
		hunger -= 1
		noodles -= 1
	pass # Replace with function body.


func _on_Timer_timeout():
	hunger += 1/total_status_time
	pass # Replace with function body.


func _on_NoodleTimer_timeout():
	$UI/Pet.set_texture(main_picture)
	pass # Replace with function body.
