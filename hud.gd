extends CanvasLayer

@onready var fuselabel = $Label
@onready var regenwait = $regenwait


var fuseval = gb.fuseval
var fusedrained = false
var newfuseval = gb.fuseval
var regenfuse = true


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fuselabel.text = str(int(fuseval))
	drainfuse()
	gainfuse()


func _on_player_exploded():
	fusedrained = true
	newfuseval -= 10

func drainfuse():
	if fusedrained:
		if newfuseval == fuseval:
			fusedrained = false
			regenwait.start()
		else:
			regenfuse = false
			regenwait.stop()
			fuseval = move_toward(fuseval,newfuseval,1)

func gainfuse():
	if regenfuse:
		fuseval = move_toward(fuseval,gb.fuseval,.3)
		newfuseval = move_toward(fuseval,gb.fuseval,.3)

func _on_regenwait_timeout():
	regenfuse = true
