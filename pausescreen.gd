extends CanvasLayer

@export var selectsfx : AudioStream
@onready var mutebutton = $mutebutton
# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_resume_pressed():
	sfx.playsound(selectsfx)
	self.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	get_tree().paused = false


func _on_quit_pressed():
	sfx.playsound(selectsfx)
	gb.reset()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://startmenu.tscn")


func _on_tutorial_pressed():
	sfx.playsound(selectsfx)
	gb.reset()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://tutorial.tscn")


func _on_fullscreen_toggled(toggled_on):
	sfx.playsound(selectsfx)
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func pause():
	if sfx.mutesfx:
		mutebutton.button_pressed = true
	else:
		mutebutton.button_pressed = false

func _on_mutebutton_toggled(toggled_on):
	if toggled_on:
		sfx.mutesfx = true
	else:
		sfx.mutesfx = false
