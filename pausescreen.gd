extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_resume_pressed():
	
	self.hide()
	get_tree().paused = false


func _on_quit_pressed():
	gb.reset()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://startmenu.tscn")


func _on_tutorial_pressed():
	gb.reset()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://tutorial.tscn")
