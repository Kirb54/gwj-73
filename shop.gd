extends Node2D
signal done

@onready var waittimer = $waittimer
@onready var discription = $discription
@onready var specialitemframe = $specialitemframe
@onready var specialitem = randi_range(0,4)
@onready var coinlabel = $coinlabel


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
const booststr = 'Boosts the power of your explosions (1.1x)'
const clock = 'Increases the time you have remaining (+20 sec)'
const boostcount = 'Increases the amout of explosions you can do midair (+1)'
const fuseincrease = 'Decreases the amout of fuse you use (0.9x)'
const cashgrab = 'Increase the amout of money you get when you kill an enemy (+1)'
const energydrink = 'Increase movement speed (1.2x)'
const doubletrouble = 'You double your explosion strengh but you also duse double of your fuse (2x)'
const floaty = 'Decrease your gravity but decrease your max health (1.3x,-1)'
const deathdefience = 'You no longer lose time when you die but you only have 1 health'
const uncontrollable = 'You can overspend your fuse but you will lose control over your direction'
const bankshare = 'Coins replace your health and you lose money on hit'

var typing = false
var focused = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	specialitemcheck()
	await done
	specialitemframe.frame = specialitem


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updatemoney()




#0 = death
#1 = uncontrol
#2 = floaty 
#3 = double
#4 = coinhealth
func specialitemcheck():
	if specialitem == 0 and gb.deathpenalty == 0:
		specialitem = randi_range(1,3)
		specialitemcheck()
	elif specialitem == 1 and gb.uncontrol:
		specialitem = randi_range(0,3)
		specialitemcheck()
	elif specialitem == 4 and gb.coinhealth:
		specialitem = randi_range(0,3)
		specialitemcheck()
	else:
		waittimer.start()
		await waittimer.timeout
		done.emit()
func addiscription(disc):
	if not typing:
		discription.text = ''
		typing = true
		for i in disc:
			discription.text = discription.text + i
			if focused:
				waittimer.start()
				await waittimer.timeout
		typing = false




func _on_strbutton_mouse_entered():
	focused = true
	addiscription(booststr)



func _on_strbutton_mouse_exited():
	focused = false


func _on_explobutton_mouse_entered():
	focused = true
	addiscription(boostcount)


func _on_explobutton_mouse_exited():
	focused = false


func _on_fusebutton_mouse_entered():
	focused = true
	addiscription(fuseincrease)


func _on_fusebutton_mouse_exited():
	focused = false


func _on_clockbutton_mouse_entered():
	focused = true
	addiscription(clock)


func _on_clockbutton_mouse_exited():
	focused = false


func _on_drinkbutton_mouse_entered():
	focused = true
	addiscription(energydrink)


func _on_drinkbutton_mouse_exited():
	focused = false


func _on_coinbutton_mouse_entered():
	focused = true
	addiscription(cashgrab)


func _on_coinbutton_mouse_exited():
	focused = false


func _on_specialitem_mouse_entered():
	focused = true
	if specialitem == 0:
		addiscription(deathdefience)
	elif specialitem == 1:
		addiscription(uncontrollable)
	elif specialitem == 2:
		addiscription(floaty)
	elif specialitem == 3:
		addiscription(doubletrouble)
	elif specialitem == 4:
		addiscription(bankshare)


func _on_specialitem_mouse_exited():
	focused = false

func updatemoney():
	coinlabel.text = 'Coins: ' + str(gb.coins)


func _on_strbutton_pressed():
	if gb.coins >= 5:
		print('extra str')
		gb.coins -= 5
		gb.booststr()


func _on_clockbutton_pressed():
	if gb.coins >= 10:
		print('moretime')
		gb.coins -= 10
		gt.time += 20


func _on_explobutton_pressed():
	if gb.coins >= 7:
		print('more bounce')
		gb.coins -= 7
		gb.boosts += 1


func _on_fusebutton_pressed():
	if gb.coins >= 4:
		print('fuse')
		gb.coins -= 4
		gb.explocost *= .9


func _on_drinkbutton_pressed():
	if gb.coins >= 5:
		print('speed')
		gb.coins -= 5
		gb.movementspeed *= 1.2


func _on_coinbutton_pressed():
	if gb.coins >= 7:
		print('money')
		gb.coins -= 5
		gb.extracoins += 1

func _on_specialitem_pressed():
	if gb.coins >= 12:
		gb.coins -= 12
		if specialitem == 0:
			print('death')
			gb.deathpenalty = 0
			gb.maxhealth = 1
		if specialitem == 1:
			print('uncontrol')
			gb.uncontrol = true
		if specialitem == 2:
			print('floaty')
			if gb.maxhealth > 1:
				gb.maxhealth -= 1
			gb.gravity *= .7
		if specialitem == 3:
			print('double')
			gb.explostr *= 2
			gb.explocost *= 2
		if specialitem == 4:
			gb.coinhealth = true


func _on_leavebutton_pressed():
	gb.level += 1
	var randlevel = randi() % levels.size()
	#levels[randlevel]
	get_tree().change_scene_to_file(levels[randlevel])
