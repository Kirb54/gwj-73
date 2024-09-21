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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	gb.reset()
	get_tree().change_scene_to_file("res://startmenu.tscn")


func _on_retry_pressed():
	gb.reset()
	var randlevel = randi() % levels.size()
	get_tree().change_scene_to_file(levels[randlevel])
