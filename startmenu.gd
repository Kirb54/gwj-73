extends Node2D

const levels = [
	"res://lvl_1.tscn",
	"res://lvl_2.tscn",
	"res://lvl_3.tscn",
	"res://lvl_4.tscn",
	"res://lvl_5.tscn",
	"res://lvl_6.tscn",
	"res://lvl_7.tscn",
	"res://lvl_8.tscn",
	"res://lvl_9.tscn",
	"res://lvl_10.tscn"
	]
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	var randlevel = randi() % levels.size()
	get_tree().change_scene_to_file(levels[randlevel])


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://tutorial.tscn")


func _on_fullscreen_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
