extends Node

var time: float = 30
var minutes: int = 0
var seconds: int = 0
var msec: int = 0
var tracking = false
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if tracking:
		time -= delta
		msec = fmod(time, 1) * 100
		seconds = fmod(time, 60)
		minutes = fmod(time, 3600) / 60
	
