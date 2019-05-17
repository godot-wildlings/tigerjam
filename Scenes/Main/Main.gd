"""
Load levels
Remove levels
Relay signals and object references if necessary

"""


extends Node

var level_container : Node2D
var current_level

var cash_on_hand # hax < can't figure out a better way to transfer cash between player instances

func _ready() -> void:
	Game.main = self
	$CanvasLayer/IntroScreen.show()
	level_container = $Levels

	current_level = load_level("Overworld")

func start_player():
	var car_node = spawn_car("Mom")
	var player = spawn_player()
	player.get_in_car(car_node)

func spawn_car(car_name: String) -> Node2D:
	var car_scene
	var car_node

	if car_name == "Mom":
		car_scene = preload("res://Scenes/Cars/CarMom.tscn")
	elif car_name == "Lucifer":
		car_scene = preload("res://Scenes/Cars/CarLucifer.tscn")

	car_node = car_scene.instance()
	current_level.add_car(car_node)
	return car_node

func spawn_player():
	var player_scene = preload("res://Scenes/Player/Player.tscn")
	var new_player = player_scene.instance()
	Game.player = new_player

	return new_player




func load_level(level_name : String ) -> Node2D:
	var overworld_scene = preload("res://Scenes/Maps/Overworld/Overworld.tscn")
	var underworld_scene = preload("res://Scenes/Maps/Underworld/Underworld.tscn")

	remove_old_level()
	var new_level
	if level_name == "Overworld":
		new_level = overworld_scene.instance()
	elif level_name == "Underworld":
		new_level = underworld_scene.instance()
	#var level_scene = load(levels[level_name])
	#var new_level = level_scene.instance()
	level_container.call_deferred("add_child", new_level)
	Game.map = new_level
	return new_level


func remove_old_level():
	if current_level != null and is_instance_valid(current_level):
		current_level.call_deferred("queue_free")

func _on_IntroScreen_completed():
	$CanvasLayer/IntroScreen.hide()
	call_deferred("start_player")

func _on_UnderworldTransitionScreen_completed():
	$CanvasLayer/TransitionToUnderworld.hide()
	call_deferred("move_to_underworld")

func move_to_underworld():
	var car_node = spawn_car("Lucifer")
	var new_player = spawn_player()
	Game.player = new_player
	new_player.get_in_car(car_node)
	new_player.cash = cash_on_hand




func _on_Player_met_the_devil(cash):
	$CanvasLayer/TransitionToUnderworld.show()

	$TransitionDelayTimer.start()

	cash_on_hand = cash

func setup_underworld():
	current_level = load_level("Underworld")


func _on_TransitionDelayTimer_timeout():
	call_deferred("setup_underworld")
