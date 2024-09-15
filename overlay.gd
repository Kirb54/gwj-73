extends CanvasLayer


signal donedeathing
signal changefin
signal doneclear

@onready var timewait = $timewait
@onready var finalwait = $finalwait
@onready var layerlabel = $layerlabel
@onready var timelabel = $timelabel
@onready var layertimer = $layerwait
@onready var cleared = $clearlabel
@onready var removetimer = false
@onready var realtime = 0
func _ready():
	layerlabel.hide()
	timelabel.hide()
	cleared.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.


func startlevel():
	get_tree().paused = true
	layerlabel.text = 'Layer ' + str(gb.level)
	layerlabel.show()
	layertimer.start()
	await layertimer.timeout
	layerlabel.hide()
	self.hide()
	get_tree().paused = false


func death():
	gt.tracking = false
	self.show()
	timelabel.text = str(gt.minutes) + ':' + str(gt.seconds) + '.' + str(gt.msec)
	timelabel.show()
	layertimer.start()
	await layertimer.timeout
	realtime = gt.time
	gt.time -= gb.deathpenalty
	print(realtime)
	print(gt.time)
	removetimer = true
	changetime()
	await changefin
	finalwait.start()
	await finalwait.timeout
	timelabel.hide()
	donedeathing.emit()


func changetime():
	if realtime != gt.time:
		realtime = move_toward(realtime,gt.time,1)
		var msec = fmod(realtime, 1) * 100
		var seconds = fmod(realtime, 60)
		var minutes = fmod(realtime, 3600) / 60
		timelabel.text = str(int(minutes)) + ':' + str(int(seconds)) + '.' + str(int(msec))
		timewait.start()
		await timewait.timeout
		changetime()
	else:
		changefin.emit()

func clear():
	self.show()
	cleared.show()
	layertimer.start()
	await layertimer.timeout
	doneclear.emit()
