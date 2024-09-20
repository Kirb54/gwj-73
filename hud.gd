extends CanvasLayer

signal boom
signal died
signal gameover


@onready var fuselabel = $Label
@onready var regenwait = $regenwait
@onready var fusetick1 = $FuseTick
@onready var fusetick2 = $FuseTick2
@onready var fusetick3 = $FuseTick3
@onready var fusetick4 = $FuseTick4
@onready var fusetick5 = $FuseTick5
@onready var fusetick6 = $FuseTick6
@onready var fusetick7 = $FuseTick7
@onready var fusetick8 = $FuseTick8
@onready var fusetick9 = $FuseTick9
@onready var fusetick10 = $FuseTick10
@onready var coinlabel = $coinlabel
@onready var timelabel = $timelabel
@onready var healthlabel = $healthlabel


var fuseval = 100
var fusedrained = false
var newfuseval = 100
var regenfuse = true
var explocost = gb.explocost
var regenrate = gb.regenrate
var regentime = gb.regentime
var health = gb.maxhealth

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fuselabel.text = str(int(fuseval))
	drainfuse()
	gainfuse()
	updatebar()
	updatecoins()
	checkempty()
	updatehealth()
	updatetime()
	checktime()


func _on_player_exploded():
	fusedrained = true
	newfuseval -= explocost
	if fuseval <= 0:
		boom.emit()

func drainfuse():
	if fusedrained:
		if newfuseval == fuseval:
			fusedrained = false
			regenwait.start(regentime)
		else:
			regenfuse = false
			regenwait.stop()
			fuseval = move_toward(fuseval,newfuseval,1)

func gainfuse():
	if regenfuse:
		fuseval = move_toward(fuseval,100,regenrate)
		newfuseval = move_toward(fuseval,100,regenrate)

func _on_regenwait_timeout():
	regenfuse = true


func updatebar():
	if fuseval < 90:
		fusetick10.hide()
	else:
		fusetick10.show()
	if fuseval < 80:
		fusetick9.hide()
	else:
		fusetick9.show()
	if fuseval < 70:
		fusetick8.hide()
	else:
		fusetick8.show()
	if fuseval < 60:
		fusetick7.hide()
	else:
		fusetick7.show()
	if fuseval < 50:
		fusetick6.hide()
	else:
		fusetick6.show()
	if fuseval < 40:
		fusetick5.hide()
	else:
		fusetick5.show()
	if fuseval < 30:
		fusetick4.hide()
	else:
		fusetick4.show()
	if fuseval < 20:
		fusetick3.hide()
	else:
		fusetick3.show()
	if fuseval < 10:
		fusetick2.hide()
	else:
		fusetick2.show()
	if fuseval < 0:
		fusetick1.hide()
	else:
		fusetick1.show()


func _on_player_hurt():
	if gb.coinhealth:
		gb.coins -= 5
		if gb.coins < 0:
			gb.coins = 0
	else:
		health -= 1

func fuseget():
	return fuseval


func updatecoins():
	coinlabel.text = 'Coins: ' + str(gb.coins)


func updatetime():
	if not gb.sandbox:
		timelabel.text = str(gt.minutes) + ':' + str(gt.seconds) + '.' + str(gt.msec)
	else:
		timelabel.hide()


func checkempty():
	if health <= 0 and not gb.sandbox:
		died.emit()

func updatehealth():
	if not gb.sandbox:
		healthlabel.text = 'Health: ' + str(health)

func checktime():
	if gt.time <= 0:
		gameover.emit()
