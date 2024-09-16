extends Node2D


@onready var overlay = $overlay
# Called when the node enters the scene tree for the first time.
func _ready():
	gt.tracking = true
	overlay.startlevel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_door_cleared():
	gt.tracking = false
	get_tree().paused = true
	overlay.clear()


func _on_player_died():
	get_tree().paused = true
	overlay.death()
	
