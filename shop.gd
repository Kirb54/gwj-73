extends Node2D
signal done

@onready var waittimer = $waittimer
@onready var discription = $discription
@onready var specialitemframe = $specialitemframe
@onready var specialitem = randi_range(0,4)
@onready var coinlabel = $coinlabel
@onready var timelabel = $timelabel
@onready var bombcost = $cost
@onready var clockcost = $cost2
@onready var explocost = $cost3
@onready var fusecost = $cost4
@onready var drinkcost = $cost5
@onready var coincost = $cost6
@onready var specialcost = $specialitemcost
@onready var layerlabel = $layerlabel

var bombprice = 5
var clockprice = 10
var exploprice = 7
var fuseprice = 4
var drinkprice = 5
var coinprice = 8
var specialprice = 12

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
const clock = 'Increases the time you have remaining (+15 sec)'
const boostcount = 'Increases the amout of explosions you can do midair (+1)'
const fuseincrease = 'Decreases the amout of fuse you use (0.9x)'
const cashgrab = 'Increase the amout of money you get when you kill an enemy (+1)'
const energydrink = 'Increase movement speed (1.2x)'
const doubletrouble = 'You double your explosion strengh but you also use double of your fuse (2x)'
const floaty = 'Decrease your gravity but decrease your max health (1.3x,-1)'
const deathdefience = 'You no longer lose time when you die but you only have 1 health'
const uncontrollable = 'You can overspend your fuse but you will lose control over your direction'
const bankshare = 'Coins replace your health and you lose money on hit'


var typing = false
var focused = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	inflation()
	specialitemcheck()
	await done
	specialitemframe.frame = specialitem
	timelabel.text = str(gt.minutes) + ':' + str(gt.seconds) + '.' + str(gt.msec)
	layerlabel.text = 'Layer: ' + str(gb.level)


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
	if gb.coins >= bombprice:
		print('extra str')
		gb.coins -= bombprice
		gb.booststr()


func _on_clockbutton_pressed():
	if gb.coins >= clockprice:
		print('moretime')
		gb.coins -= clockprice
		gt.time += 15


func _on_explobutton_pressed():
	if gb.coins >= exploprice:
		print('more bounce')
		gb.coins -= exploprice
		gb.boosts += 1


func _on_fusebutton_pressed():
	if gb.coins >= fuseprice:
		print('fuse')
		gb.coins -= fuseprice
		gb.explocost *= .9


func _on_drinkbutton_pressed():
	if gb.coins >= drinkprice:
		print('speed')
		gb.coins -= drinkprice
		gb.movementspeed *= 1.2


func _on_coinbutton_pressed():
	if gb.coins >= coinprice:
		print('money')
		gb.coins -= coinprice
		gb.extracoins += 1

func _on_specialitem_pressed():
	if gb.coins >= specialprice:
		gb.coins -= specialprice
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
			if gb.explostr >= 6000:
				gb.explostr = 6000
			gb.explocost *= 2
		if specialitem == 4:
			gb.coinhealth = true

func inflation():
	var increase = (gb.level / 10) + 1
	bombprice *= increase
	print(bombprice)
	bombcost.text = str(bombprice)
	clockprice *= increase
	clockcost.text = str(clockprice)
	exploprice *= increase
	explocost.text = str(exploprice)
	fuseprice *= increase
	fusecost.text = str(fuseprice)
	drinkprice *= increase
	drinkcost.text = str(drinkprice)
	coinprice *= increase
	coincost.text = str(coinprice)
	specialprice *= increase
	specialcost.text = str(specialprice)


func _on_leavebutton_pressed():
	gb.level += 1
	var randlevel = randi() % levels.size()
	#levels[randlevel]
	get_tree().change_scene_to_file(levels[randlevel])
