extends Node2D


@onready var waittimer = $waittimer
@onready var discription = $discription
@onready var specialitemframe = $specialitemframe
@onready var specialitem = randi_range(0,3)
@onready var coinlabel = $coinlabel



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

var typing = false
var focused = false

func _ready():
	specialitemframe.frame = specialitem


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updatemoney()

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
	if gb.coins >= 7:
		print('moretime')
		gb.coins -= 7
		gt.time += 20


func _on_explobutton_pressed():
	if gb.coins >= 10:
		print('more bounce')
		gb.coins -= 10
		gb.boosts += 1


func _on_fusebutton_pressed():
	if gb.coins >= 5:
		print('fuse')
		gb.coins -= 5
		gb.explocost *= .9


func _on_drinkbutton_pressed():
	if gb.coins >= 3:
		print('speed')
		gb.coins -= 3
		gb.movementspeed *= 1.2


func _on_coinbutton_pressed():
	if gb.coins >= 5:
		print('money')
		gb.coins -= 5
		gb.extracoins += 1

#0 = death
#1 = uncontrol
#2 = floaty 
#3 = double
func _on_specialitem_pressed():
	if gb.coins >= 15:
		gb.coins -= 15
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
		


func _on_leavebutton_pressed():
	gb.level += 1
	get_tree().change_scene_to_file("res://lvl_1.tscn")
